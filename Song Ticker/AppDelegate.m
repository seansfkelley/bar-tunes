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

NSString *formatStringDefaultsKey = @"formatString";
NSString *playerDefaultsKey = @"player";


- (void) awakeFromNib {
    itunes = [SBApplication applicationWithBundleIdentifier:@"com.apple.iTunes"];
    spotify = [SBApplication applicationWithBundleIdentifier:@"com.spotify.client"];
    
    scrollText = [[ScrollingTextView alloc] init];
    
    [formatHandler setAppDelegate:self];
    [formatHandler setAnchor:scrollText];
    
    [menuHandler setAppDelegate:self];
    
    NSStatusItem *statusItem = [[NSStatusBar systemStatusBar] statusItemWithLength:NSVariableStatusItemLength];
    [statusItem setHighlightMode:YES];
    [statusItem setView:scrollText];
    [statusItem setMenu:menuHandler];
    
    [scrollText setStatusItem:statusItem];
    [scrollText setFormatWindow:formatHandler];
    
    // Default startup options. Replace with saved information from user.
    
    [menuHandler setWatchItunes:nil];
    
    [[NSDistributedNotificationCenter defaultCenter] addObserver:self
                                                        selector:@selector(playerStateChangeNotification:)
                                                            name:@"com.apple.iTunes.playerInfo"
                                                          object:nil];
    
    [[NSDistributedNotificationCenter defaultCenter] addObserver:self
                                                        selector:@selector(playerStateChangeNotification:)
                                                            name:@"com.spotify.client.PlaybackStateChanged"
                                                          object:nil];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    formatString = [defaults objectForKey:formatStringDefaultsKey];
    if (formatString == nil) {
        formatString = @"%artist — %song";
    }
    
    Player p = [defaults integerForKey:playerDefaultsKey];
    [menuHandler setWatch:p];
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

- (Player) getCurrentPlayer {
    if (currentPlayer == itunes) {
        return ITUNES;
    } else if (currentPlayer == spotify) {
        return SPOTIFY;
    } else if (currentPlayer == nil) {
        return ANY;
    } else {
        assert(NO);
    }
}

- (void) setFormatString:(NSString *)f {
    formatString = f;
    [self setDisplayStringFromPlayerState:[self getPlayerState]];
}

- (IBAction) quitApplication:(id)sender {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:formatString forKey:formatStringDefaultsKey];
    [defaults setInteger:[self getCurrentPlayer] forKey:playerDefaultsKey];
    [[NSApplication sharedApplication] terminate:nil];
}

- (void) closeFormatWindowWithoutSaving {
    [formatHandler closeWindowWithoutSettingString:self];
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
