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
@synthesize displayedPlayer;
@synthesize currentPlayer;

NSString *formatStringDefaultsKey = @"formatString";
NSString *playerDefaultsKey = @"player";

NSString *itunesNoteName = @"com.apple.iTunes.playerInfo";
NSString *spotifyNoteName = @"com.spotify.client.PlaybackStateChanged";

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
    
    [[NSDistributedNotificationCenter defaultCenter] addObserver:self
                                                        selector:@selector(playerStateChangeNotification:)
                                                            name:itunesNoteName
                                                          object:nil];
    
    [[NSDistributedNotificationCenter defaultCenter] addObserver:self
                                                        selector:@selector(playerStateChangeNotification:)
                                                            name:spotifyNoteName
                                                          object:nil];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    formatString = [defaults objectForKey:formatStringDefaultsKey];
    if (formatString == nil) {
        formatString = @"%artist — %song";
    }
    
    Player p = [defaults integerForKey:playerDefaultsKey];
    [menuHandler setWatch:p];
    
    if ([self getItunesPlayerState] == PLAY) {
        [self setCurrentPlayer:ITUNES];
    } else if ([self getSpotifyPlayerState] == PLAY) {
        [self setCurrentPlayer:SPOTIFY];
    } else if ([self getItunesPlayerState] == PAUSE) {
        [self setCurrentPlayer:ITUNES];
    } else if ([self getSpotifyPlayerState] == PAUSE) {
        [self setCurrentPlayer:SPOTIFY];
    } else {
        [self setCurrentPlayer:NONE];
    }
}

- (PlayerState) getPlayerState {
    if (displayedPlayer == ITUNES || (displayedPlayer == ANY && currentPlayer == ITUNES)) {
        return [self getItunesPlayerState];
    } else if (displayedPlayer == SPOTIFY  || (displayedPlayer == ANY && currentPlayer == SPOTIFY)) {
        return [self getSpotifyPlayerState];
    } else if (displayedPlayer == ANY && currentPlayer == NONE) {
        return STOP;
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

- (id) getCurrentTrack {
    // We know that iTunes and Spotify both support the currentTrack message.
    if (displayedPlayer == ITUNES || (displayedPlayer == ANY && currentPlayer == ITUNES)) {
        return [itunes currentTrack];
    } else if (displayedPlayer == SPOTIFY  || (displayedPlayer == ANY && currentPlayer == SPOTIFY)) {
        return [spotify currentTrack];
    } else {
        assert(NO);
    }
}

- (void) setDisplayedPlayer:(Player)p {
    displayedPlayer = p;
    [self setDisplayStringFromPlayerState:[self getPlayerState]];
}

- (void) setCurrentPlayer:(Player)p {
    currentPlayer = p;
    [menuHandler setWatchAnyCurrentPlayer:currentPlayer];
}

- (void) setFormatString:(NSString *)f {
    formatString = f;
    [self setDisplayStringFromPlayerState:[self getPlayerState]];
}

- (IBAction) quitApplication:(id)sender {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:formatString forKey:formatStringDefaultsKey];
    [defaults setInteger:[self displayedPlayer] forKey:playerDefaultsKey];
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
    // Both iTunes and Spotify have a Player State -> Playing in their userInfo.
    NSString *state = [[note userInfo] objectForKey:@"Player State"];
    NSString *player = [note name];
    if ([state isEqualToString:@"Playing"]) {
        if ([player isEqualToString:itunesNoteName]) {
            [self setCurrentPlayer:ITUNES];
        } else if ([player isEqualToString:spotifyNoteName]) {
            [self setCurrentPlayer:SPOTIFY];
        } else {
            assert(NO);
        }
    } else if ([state isEqualToString:@"Paused"] || [state isEqualToString:@"Stopped"]) {
        if ([player isEqualToString:itunesNoteName] && [self getSpotifyPlayerState] == PLAY) {
            [self setCurrentPlayer:SPOTIFY];
        } else if ([player isEqualToString:spotifyNoteName] && [self getItunesPlayerState] == PLAY) {
            [self setCurrentPlayer:ITUNES];
        }
    }
    [self setDisplayStringFromPlayerState:[self getPlayerState]];
}

- (void) setDisplayStringFromPlayerState:(PlayerState)state {
    [scrollText setState:state];
    if (state == STOP) {
        [scrollText clear];
        return;
    }
    
    // We know that iTunes and Spotify both support this message.
    id track = [self getCurrentTrack];
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
