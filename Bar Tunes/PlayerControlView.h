#import <Foundation/Foundation.h>
#import "UnifiedPlayerModel.h"

@interface PlayerControlView : NSMenu {
    IBOutlet NSMenuItem *itunesMenuItem;
    IBOutlet NSMenuItem *spotifyMenuItem;
    IBOutlet NSMenuItem *anyPlayerMenuItem;
}

@property UnifiedPlayerModel *model;

- (void) setWatch:(Player)p;
- (IBAction) setWatchItunes:(id)sender;
- (IBAction) setWatchSpotify:(id)sender;
- (IBAction) setWatchAny:(id)sender;

@end
