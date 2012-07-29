#import <Cocoa/Cocoa.h>
#import "iTunes.h"
#import "Spotify.h"
#import "FormatStringPackage.h"
#import "DisplayPackage.h"
#import "PlayerPackage.h"
#import "NSStatusBar+Undocumented.h"

@interface AppDelegate : NSObject <NSApplicationDelegate> {
    FormatStringModel *formatModel;
    IBOutlet FormatStringView *formatView;
    IBOutlet FormatStringController *formatController;
    
    DisplayModel *displayModel;
    IBOutlet ScrollingTextView *displayView;
    IBOutlet DisplayController *displayController;
    
    PlayerModel *playerModel;
    IBOutlet PlayerControlView *playerControlView;
    IBOutlet PlayerController *playerController;
}

- (IBAction) quitApplication:(id)sender;

@end

/*
To do (ordered by approximate priority):
 app icon

Questions:
 how to handle crash/force-quit of application we're listening to?
 when and why is itunes being kept open?
 scroll while menu is selected?
*/