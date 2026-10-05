#import "../Utils.h"

// Keep only the "network" tabs: My Network, Notifications and Jobs (messaging stays in the top bar)

static UIViewController *PSIRootOfTab(UIViewController *controller) {
    if ([controller isKindOfClass:[UINavigationController class]]) {
        return ((UINavigationController *)controller).viewControllers.firstObject ?: controller;
    }

    return controller;
}

static BOOL PSIShouldHideTab(UIViewController *controller) {
    NSString *rootClass = NSStringFromClass([PSIRootOfTab(controller) class]);
    NSString *title = controller.tabBarItem.title ?: @"";
    NSString *tabId = controller.tabBarItem.accessibilityIdentifier ?: @"";

    // Tabs are matched by their stable ID (Home 12000, Post 13634) and by screen class, since
    // LinkedIn serves different feed screens (FeedViewController, FeedSDUIViewController) and wrappers
    if ([PSIUtils getBoolPref:@"hide_feed_tab"] && ([tabId isEqualToString:@"12000"] || [rootClass hasPrefix:@"VoyagerFeed.Feed"])) return YES;
    if ([PSIUtils getBoolPref:@"hide_post_tab"] && ([tabId isEqualToString:@"13634"] || [rootClass containsString:@"ContentCompose"])) return YES;
    if ([PSIUtils getBoolPref:@"hide_video_tab"] && ([rootClass containsString:@"Video"] || [title isEqualToString:@"Video"])) return YES;

    return NO;
}

@interface LINMainNavViewController : UITabBarController
@end

%hook LINMainNavViewController
- (void)setViewControllers:(NSArray *)viewControllers animated:(BOOL)animated {
    NSMutableArray *kept = [NSMutableArray array];
    for (UIViewController *controller in viewControllers) {
        if (!PSIShouldHideTab(controller)) [kept addObject:controller];
    }

    if (kept.count != viewControllers.count) {
        PSILog(@"Hiding %lu of %lu tabs", (unsigned long)(viewControllers.count - kept.count), (unsigned long)viewControllers.count);
    }

    // Never leave the tab bar empty
    %orig(kept.count > 0 ? kept : viewControllers, animated);
}

// LinkedIn may try to select a removed tab (e.g. Home on launch); stay on a kept one instead
- (void)setSelectedViewController:(UIViewController *)selectedViewController {
    if (selectedViewController && ![self.viewControllers containsObject:selectedViewController]) {
        %orig(self.viewControllers.firstObject);
        return;
    }

    %orig;
}

- (void)setSelectedIndex:(NSUInteger)selectedIndex {
    %orig(selectedIndex < self.viewControllers.count ? selectedIndex : 0);
}
%end

///////////////////////////////////////////////////////////

// Full-screen vertical video feed ("video chaining"), opened from posts and other entry points

static BOOL PSIIsVideoFeed(UIViewController *controller) {
    // The video feed itself, and the loader screen that wraps it
    return [NSStringFromClass([PSIRootOfTab(controller) class]) hasPrefix:@"MediaView.MediaVideoChaining"];
}

%hook UIViewController
- (void)presentViewController:(UIViewController *)controller animated:(BOOL)animated completion:(void (^)(void))completion {
    if ([PSIUtils getBoolPref:@"hide_video_tab"] && PSIIsVideoFeed(controller)) {
        PSILog(@"Blocked video feed");

        if (completion) completion();
        return;
    }

    %orig;
}
%end

%hook UINavigationController
- (void)pushViewController:(UIViewController *)controller animated:(BOOL)animated {
    if ([PSIUtils getBoolPref:@"hide_video_tab"] && PSIIsVideoFeed(controller)) {
        PSILog(@"Blocked video feed");
        return;
    }

    %orig;
}
%end
