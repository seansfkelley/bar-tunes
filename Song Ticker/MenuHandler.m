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

- (IBAction) setWatchItunes:(id)sender {
    [appDelegate setCurrentPlayer:ITUNES];
    [itunesMenuItem setState:NSOnState];
    [spotifyMenuItem setState:NSOffState];
    [anyPlayerMenuItem setState:NSOffState];
}

- (IBAction) setWatchSpotify:(id)sender {
    [appDelegate setCurrentPlayer:SPOTIFY];
    [itunesMenuItem setState:NSOffState];
    [spotifyMenuItem setState:NSOnState];
    [anyPlayerMenuItem setState:NSOffState];
}

- (IBAction) setWatchAny:(id)sender {
    [appDelegate setCurrentPlayer:ANY];
    [itunesMenuItem setState:NSOffState];
    [spotifyMenuItem setState:NSOffState];
    [anyPlayerMenuItem setState:NSOnState];
}

@end
