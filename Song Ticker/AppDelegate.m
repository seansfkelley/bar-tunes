//
//  AppDelegate.m
//  Song Ticker
//
//  Created by Sean Kelley on 7/19/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "AppDelegate.h"

@implementation AppDelegate

@synthesize displayedPlayer;
@synthesize currentPlayer;

NSString *itunesNoteName = @"com.apple.iTunes.playerInfo";
NSString *spotifyNoteName = @"com.spotify.client.PlaybackStateChanged";

- (void) awakeFromNib {
    NSString *defaultPrefsFile = [[NSBundle mainBundle] pathForResource:@"DefaultPreferences" ofType:@"plist"];
    NSDictionary *defaultPreferences = [NSDictionary dictionaryWithContentsOfFile:defaultPrefsFile];
    [[NSUserDefaults standardUserDefaults] registerDefaults:defaultPreferences];
    
    itunes = [SBApplication applicationWithBundleIdentifier:@"com.apple.iTunes"];
    spotify = [SBApplication applicationWithBundleIdentifier:@"com.spotify.client"];
    
    // Display MVC
    displayModel = [[DisplayModel alloc] init];
    [displayView setModel:displayModel];
    [displayController setModel:displayModel];
    
    // Display other
    [displayView setFormatController:formatController];
    
    // Format MVC
    formatModel = [[FormatStringModel alloc] init];
    [formatView setModel:formatModel];
    [formatController setModel:formatModel];
    [formatController setView:formatView];
    
    // Format other
    [formatView setAnchor:displayView];
    
    // Link up listeners
    [formatModel addObserver:displayController forKeyPath:@"formatString" options:NSKeyValueObservingOptionNew context:(__bridge void *)(self)];
    [displayModel addObserver:displayView forKeyPath:@"state" options:NSKeyValueObservingOptionNew context:nil];
    [displayModel addObserver:displayView forKeyPath:@"text" options:NSKeyValueObservingOptionNew context:nil];
    
    [menuHandler setAppDelegate:self];
    
    NSStatusBar *systemStatusBar = [NSStatusBar systemStatusBar];
    NSStatusItem *statusItem = nil;
    
    // Undocumented behavior; may not always work. Fallback to standard behavior.
    if ([systemStatusBar respondsToSelector: @selector (_statusItemWithLength:withPriority:)]) {
        statusItem = [systemStatusBar _statusItemWithLength:0 withPriority:0];
        [statusItem setLength:NSVariableStatusItemLength];
    } else {
        statusItem = [systemStatusBar statusItemWithLength:NSVariableStatusItemLength];
    }
    
    [statusItem setHighlightMode:YES];
    [statusItem setView:displayView];
    [statusItem setMenu:menuHandler];
    
    [displayView setStatusItem:statusItem];
    
    [[NSDistributedNotificationCenter defaultCenter] addObserver:self
                                                        selector:@selector(playerStateChangeNotification:)
                                                            name:itunesNoteName
                                                          object:nil];
    
    [[NSDistributedNotificationCenter defaultCenter] addObserver:self
                                                        selector:@selector(playerStateChangeNotification:)
                                                            name:spotifyNoteName
                                                          object:nil];
    
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
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    Player p = [defaults integerForKey:DEFAULTS_KEY_PLAYER];
    [menuHandler setWatch:p];
    NSString *formatString = [defaults objectForKey:DEFAULTS_KEY_FORMAT_STRING];
    if (formatString == nil) {
        formatString = @"%artist — %song";
    }
    [formatModel setFormatString:formatString];
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
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setInteger:[self displayedPlayer] forKey:DEFAULTS_KEY_PLAYER];
    [defaults synchronize];
    // Janky refresh.
    [formatModel setFormatString:[formatModel formatString]];
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
    [formatModel setFormatString:[formatModel formatString]];
}

- (NSString*) album {
    if ([displayModel state] != STOP) {
        return [[self getCurrentTrack] album];
    }
    return @"";
}

- (NSString*) artist {
    if ([displayModel state] != STOP) {
        return [[self getCurrentTrack] artist];
    }
    return @"";
}

- (NSString*) name {
    if ([displayModel state] != STOP) {
        return [[self getCurrentTrack] name];
    }
    return @"";
}

- (NSInteger) trackNumber {
    if ([displayModel state] != STOP) {
        return [[self getCurrentTrack] trackNumber];
    }
    return 0;
}

@end
