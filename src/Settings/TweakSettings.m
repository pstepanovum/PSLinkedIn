#import "TweakSettings.h"
#import "PSISettingsBackup.h"

@implementation PSITweakSettings

// MARK: - Sections

///
/// This returns an array of sections, with each section consisting of a dictionary
///
/// `"title"`: The section title (leave blank for no title)
///
/// `"rows"`: An array of **PSISetting** classes, potentially containing a "navigationCellWithTitle" initializer to allow for nested setting pages.
///
/// `"footer`: The section footer (leave blank for no footer)

+ (NSArray *)sections {
    return @[
        @{
            @"header": @"Tabs",
            @"rows": @[
                [PSISetting switchCellWithTitle:@"Hide Home feed tab" subtitle:@"Removes the home feed from the bottom tab bar" defaultsKey:@"hide_feed_tab" requiresRestart:YES],
                [PSISetting switchCellWithTitle:@"Block video feed" subtitle:@"Blocks the full-screen vertical video feed (and a Video tab, if shown)" defaultsKey:@"hide_video_tab" requiresRestart:YES],
                [PSISetting switchCellWithTitle:@"Hide Post tab" subtitle:@"Removes the post button from the bottom tab bar" defaultsKey:@"hide_post_tab" requiresRestart:YES]
            ],
            @"footer": @"My Network, Notifications and Jobs stay, and messaging stays in the top bar. The app opens on My Network."
        },
        @{
            @"header": @"Debug",
            @"rows": @[
                [PSISetting switchCellWithTitle:@"Enable FLEX gesture" subtitle:@"Hold 5 fingers on the screen to open the FLEX explorer" defaultsKey:@"flex_gesture"]
            ]
        },
        @{
            @"header": @"About",
            @"rows": @[
                [PSISetting linkCellWithTitle:@"GitHub" subtitle:@"@pstepanovum" icon:[PSISymbol symbolWithName:@"person.crop.circle"] url:@"https://github.com/pstepanovum"],
                [PSISetting linkCellWithTitle:@"Repository" subtitle:@"pstepanovum/PSLinkedIn" icon:[PSISymbol symbolWithName:@"chevron.left.forwardslash.chevron.right"] url:@"https://github.com/pstepanovum/PSLinkedIn"]
            ],
            @"footer": [NSString stringWithFormat:@"PSLinkedIn %@\n\nLinkedIn v%@", PSIVersionString, [PSIUtils appVersionString]]
        }
    ];
}


// MARK: - Title

+ (NSString *)title {
    return @"PSLinkedIn Settings";
}


// MARK: - Menus

+ (NSDictionary *)menus {
    return @{};
}

@end
