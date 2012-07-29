#import <Cocoa/Cocoa.h>
#import "iTunes.h"
#import "Spotify.h"
#import "FormatStringPackage.h"
#import "DisplayPackage.h"
#import "PlayerPackage.h"
#import "NSStatusBar+Undocumented.h"
#import "LaunchAtLoginController.h"

@interface AppDelegate : NSObject <NSApplicationDelegate> {
    FormatStringModel *formatModel;
    IBOutlet FormatStringView *formatView;
    IBOutlet FormatStringController *formatController;
    
    DisplayModel *displayModel;
    IBOutlet ScrollingTextView *displayView;
    IBOutlet DisplayController *displayController;
    
    UnifiedPlayerModel *playerModel;
    IBOutlet PlayerControlView *playerControlView;
    IBOutlet PlayerController *playerController;
    
    IBOutlet NSMenuItem *loginItemMenuItem;
}

- (IBAction) toggleSetLoginItem:(id)sender;
- (IBAction) quitApplication:(id)sender;

@end

/*
 refactor unified class to refer directly to models instead of having
 to go through enum every single time?
 
 fix leaks during refactoring
 
 move string-insertion code from format view to format controller
*/