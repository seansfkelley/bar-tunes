//
//  AppDelegate.m
//  Song Ticker
//
//  Created by Sean Kelley on 7/19/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "AppDelegate.h"

@implementation AppDelegate

@synthesize formatString;

- (void) awakeFromNib {
    itunes = [SBApplication applicationWithBundleIdentifier:@"com.apple.iTunes"];
    spotify = [SBApplication applicationWithBundleIdentifier:@"com.spotify.client"];
    
    scrollText = [[ScrollingTextView alloc] init];
    
    [formatHandler setAppDelegate:self];
    [formatHandler setAnchor:scrollText];
    
    [menuHandler setAppDelegate:self];
    
    NSStatusItem* statusItem = [[NSStatusBar systemStatusBar] statusItemWithLength:NSVariableStatusItemLength];
    [statusItem setHighlightMode:YES];
    [statusItem setView:scrollText];
    [statusItem setMenu:menuHandler];
    
    [scrollText setStatusItem:statusItem];
    
    // Default startup options. Replace with saved information from user.
    formatString = @"%artist — %song";
    [menuHandler setWatchItunes:nil];
    
    [[NSDistributedNotificationCenter defaultCenter] addObserver:self
                                                        selector:@selector(playerStateChangeNotification:)
                                                            name:@"com.apple.iTunes.playerInfo"
                                                          object:nil];
    
    [[NSDistributedNotificationCenter defaultCenter] addObserver:self
                                                        selector:@selector(playerStateChangeNotification:)
                                                            name:@"com.spotify.client.PlaybackStateChanged"
                                                          object:nil];
}

- (PlayerState) getPlayerState {
    if (currentPlayer == nil) {
        return STOP;
    } else if (currentPlayer == itunes) {
        return [self getItunesPlayerState];
    } else if (currentPlayer == spotify) {
        return [self getSpotifyPlayerState];
    } else {
        assert(NO);
    }
}

- (PlayerState) getItunesPlayerState {
    if (![itunes isRunning]) {
        return STOP;
    } else if ([itunes playerState] == iTunesEPlSPlaying) {
        return PLAY;
    } else if ([itunes playerState] == iTunesEPlSPaused) {
        return PAUSE;
    } else {
        return STOP;
    }
}

- (PlayerState) getSpotifyPlayerState {
    if (![spotify isRunning]) {
        return STOP;
    } else if ([spotify playerState] == SpotifyEPlSPlaying) {
        return PLAY;
    } else if ([spotify playerState] == SpotifyEPlSPaused) {
        return PAUSE;
    } else {
        return STOP;
    }
}

- (void) setCurrentPlayer:(Player)p {
    if (p == ITUNES) {
        currentPlayer = itunes;
    } else if (p == SPOTIFY) {
        currentPlayer = spotify;
    } else if (p == ANY) {
        currentPlayer = nil;
    } else {
        assert(NO);
    }
    [self setDisplayStringFromPlayerState:[self getPlayerState]];
}

- (void) setFormatString:(NSString *)f {
    formatString = f;
    [self setDisplayStringFromPlayerState:[self getPlayerState]];
}

- (IBAction) quitApplication:(id)sender {
    [[NSApplication sharedApplication] terminate:nil];
}

- (void) printNotification:(NSNotification*)note {
    NSString *object = [note object];
    NSString *name = [note name];
    NSDictionary *userInfo = [note userInfo];
    NSLog(@"<%p>%s: object: %@ name: %@ userInfo: %@", self, __PRETTY_FUNCTION__, object, name, userInfo);
}

- (void) playerStateChangeNotification:(NSNotification*)note {
    [self setDisplayStringFromPlayerState:[self getPlayerState]];
}

- (void) setDisplayStringFromPlayerState:(PlayerState)state {
    if (currentPlayer == nil || ![currentPlayer isRunning]) {
        [scrollText setState:STOP];
        [scrollText clear];
        return;
    }
    
    [scrollText setState:state];
    if (state == STOP) {
        [scrollText clear];
        return;
    }
    
    // We know that iTunes and Spotify both support this message.
    id track = [((id) currentPlayer) currentTrack];
    // Could also be done with a string -> SEL dictionary...
    NSString *displayString = [formatString 
                     stringByReplacingOccurrencesOfString:@"%artist" withString:[track artist]];
    displayString = [displayString 
                     stringByReplacingOccurrencesOfString:@"%album" withString:[track album]];
    displayString = [displayString 
                     stringByReplacingOccurrencesOfString:@"%song" withString:[track name]];
    displayString = [displayString 
                     stringByReplacingOccurrencesOfString:@"%number" withString:[NSString stringWithFormat:@"%d", [track trackNumber]]];
    
    [scrollText setText:displayString];
}

@end
