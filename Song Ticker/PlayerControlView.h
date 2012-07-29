#import <Foundation/Foundation.h>
#import "PlayerModel.h"

@interface PlayerControlView : NSMenu {
    IBOutlet NSMenuItem *itunesMenuItem;
    IBOutlet NSMenuItem *spotifyMenuItem;
    IBOutlet NSMenuItem *anyPlayerMenuItem;
}

@property PlayerModel *model;

- (void) setWatch:(Player)p;
- (IBAction) setWatchItunes:(id)sender;
- (IBAction) setWatchSpotify:(id)sender;
- (IBAction) setWatchAny:(id)sender;

@end
