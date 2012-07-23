//
//  AppDelegate.m
//  Song Ticker
//
//  Created by Sean Kelley on 7/19/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "AppDelegate.h"

@implementation AppDelegate

- (void) awakeFromNib {
    itunes = [SBApplication applicationWithBundleIdentifier:@"com.apple.iTunes"];
    spotify = [SBApplication applicationWithBundleIdentifier:@"com.spotify.client"];
        
    scrollText = [[ScrollingTextView alloc] init];
    
    NSStatusItem* statusItem = [[NSStatusBar systemStatusBar] statusItemWithLength:NSVariableStatusItemLength];
    [statusItem setHighlightMode:YES];
    [statusItem setView:scrollText];
    [statusItem setMenu:statusMenu];
    
    [scrollText setStatusItem:statusItem];
    
    formatString = @"%artist — %song";
    
    [self setDisplayStringFromPlayerState:[self getItunesPlayerState]];
    
    [[NSDistributedNotificationCenter defaultCenter] addObserver:self
                                                        selector:@selector(PlayerStateChangeNotification:)
                                                            name:@"com.apple.iTunes.playerInfo"
                                                          object:nil];
    
    [[NSDistributedNotificationCenter defaultCenter] addObserver:self
                                                        selector:@selector(PlayerStateChangeNotification:)
                                                            name:@"com.spotify.client.PlaybackStateChanged"
                                                          object:nil];
}

- (IBAction) bringFormatWindowToFront:(id)sender{
    [NSApp activateIgnoringOtherApps:YES];
    [formatWindow makeKeyAndOrderFront:nil];
    [formatField setObjectValue:formatString];
}

- (IBAction) closeWindowAndSetFormatString:(id)sender {
    formatString = [formatField objectValue];
    [formatWindow close];
    [self setDisplayStringFromPlayerState:[self getPlayerState]];
}

- (IBAction) setWatchItunes:(id)sender {
    currentPlayer = itunes;
    [itunesMenuItem setState:NSOnState];
    [spotifyMenuItem setState:NSOffState];
    [anyPlayerMenuItem setState:NSOffState];
    [self setDisplayStringFromPlayerState:[self getItunesPlayerState]];
}
- (IBAction) setWatchSpotify:(id)sender {
    currentPlayer = spotify;
    [itunesMenuItem setState:NSOffState];
    [spotifyMenuItem setState:NSOnState];
    [anyPlayerMenuItem setState:NSOffState];
    [self setDisplayStringFromPlayerState:[self getSpotifyPlayerState]];
}
- (IBAction) setWatchAny:(id)sender {
    currentPlayer = nil;
    [itunesMenuItem setState:NSOffState];
    [spotifyMenuItem setState:NSOffState];
    [anyPlayerMenuItem setState:NSOnState];
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
    if ([itunes playerState] == iTunesEPlSPlaying) {
        return PLAY;
    } else if ([itunes playerState] == iTunesEPlSPaused) {
        return PAUSE;
    } else {
        return STOP;
    }
}

- (PlayerState) getSpotifyPlayerState {
    if ([spotify playerState] == SpotifyEPlSPlaying) {
        return PLAY;
    } else if ([spotify playerState] == SpotifyEPlSPaused) {
        return PAUSE;
    } else {
        return STOP;
    }
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

- (void) PlayerStateChangeNotification:(NSNotification*)note {
    [self setDisplayStringFromPlayerState:[self getPlayerState]];
}

- (void) setDisplayStringFromPlayerState:(PlayerState)state {
    if (currentPlayer == nil) {
        [scrollText setState:STOP];
        [scrollText clear];
        return;
    }
    
    [scrollText setState:state];
    if (state == STOP) {
        [scrollText clear];
        return;
    }
    
    id track = [currentPlayer currentTrack];
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
