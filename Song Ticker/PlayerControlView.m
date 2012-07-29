#import "PlayerControlView.h"

@implementation PlayerControlView

@synthesize model;

- (void) setWatch:(Player)p {
    if (p == ITUNES) {
        [self setWatchItunes:nil];
    } else if (p == SPOTIFY) {
        [self setWatchSpotify:nil];
    } else if (p == ANY) {
        [self setWatchAny:nil];
    } else {
        assert(NO);
    }
}

- (IBAction) setWatchItunes:(id)sender {
    [model setDisplayPlayer:ITUNES];
    [itunesMenuItem setState:NSOnState];
    [spotifyMenuItem setState:NSOffState];
    [anyPlayerMenuItem setState:NSOffState];
}

- (IBAction) setWatchSpotify:(id)sender {
    [model setDisplayPlayer:SPOTIFY];
    [itunesMenuItem setState:NSOffState];
    [spotifyMenuItem setState:NSOnState];
    [anyPlayerMenuItem setState:NSOffState];
}

- (IBAction) setWatchAny:(id)sender {
    [model setDisplayPlayer:ANY];
    [itunesMenuItem setState:NSOffState];
    [spotifyMenuItem setState:NSOffState];
    [anyPlayerMenuItem setState:NSOnState];
}

@end
