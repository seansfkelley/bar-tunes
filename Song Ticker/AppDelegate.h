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
    
    UnifiedPlayerModel *playerModel;
    IBOutlet PlayerControlView *playerControlView;
    IBOutlet PlayerController *playerController;
}

- (IBAction) quitApplication:(id)sender;

@end

/*
Questions:
 option for Open at Login
*/