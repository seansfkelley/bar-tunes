//
//  MenuHandler.m
//  Song Ticker
//
//  Created by Sean Kelley on 7/23/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "MenuHandler.h"

@implementation MenuHandler

@synthesize appDelegate;

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
    [appDelegate setDisplayedPlayer:ITUNES];
    [itunesMenuItem setState:NSOnState];
    [spotifyMenuItem setState:NSOffState];
    [anyPlayerMenuItem setState:NSOffState];
}

- (IBAction) setWatchSpotify:(id)sender {
    [appDelegate setDisplayedPlayer:SPOTIFY];
    [itunesMenuItem setState:NSOffState];
    [spotifyMenuItem setState:NSOnState];
    [anyPlayerMenuItem setState:NSOffState];
}

- (IBAction) setWatchAny:(id)sender {
    [appDelegate setDisplayedPlayer:ANY];
    [itunesMenuItem setState:NSOffState];
    [spotifyMenuItem setState:NSOffState];
    [anyPlayerMenuItem setState:NSOnState];
}

@end
