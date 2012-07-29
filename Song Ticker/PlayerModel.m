#import "PlayerModel.h"

@implementation PlayerModel

@synthesize itunes;
@synthesize spotify;

- (PlayerModel*) init {
    self = [super init];
    initialized = NO;
    return self;
}

- (void) initialize {
    assert(!initialized);
    if ([self itunesPlayerState] == PLAY) {
        currentPlayer = ITUNES;
    } else if ([self spotifyPlayerState] == PLAY) {
        currentPlayer = SPOTIFY;
    } else if ([self itunesPlayerState] == PAUSE) {
        currentPlayer = ITUNES;
    } else if ([self spotifyPlayerState] == PAUSE) {
        currentPlayer = SPOTIFY;
    } else {
        currentPlayer = NONE;
    }
    
    displayPlayer = ANY;
    
    initialized = YES;
}

- (PlayerState) state {
    assert(initialized);
    if (displayPlayer == ITUNES || (displayPlayer == ANY && currentPlayer == ITUNES)) {
        return [self itunesPlayerState];
    } else if (displayPlayer == SPOTIFY  || (displayPlayer == ANY && currentPlayer == SPOTIFY)) {
        return [self spotifyPlayerState];
    } else if (displayPlayer == ANY && currentPlayer == NONE) {
        return STOP;
    } else {
        assert(NO);
    }
}

- (PlayerState) itunesPlayerState {
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

- (PlayerState) spotifyPlayerState {
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

- (void) setDisplayPlayer:(Player)p {
    assert(initialized);
    [self willChangeValueForKey:@"player"];
    displayPlayer = p;
    [self didChangeValueForKey:@"player"];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setInteger:displayPlayer forKey:DEFAULTS_KEY_PLAYER];
    [defaults synchronize];
}

- (void) setCurrentPlayer:(Player)p {
    currentPlayer = p;
}

- (Player) player {
    assert(initialized);
    if (displayPlayer == ANY) {
        return currentPlayer;
    }
    return displayPlayer;
}

- (id) getCurrentTrack {
    assert(initialized);
    // We know that iTunes and Spotify both support the currentTrack message.
    if (displayPlayer == ITUNES || (displayPlayer == ANY && currentPlayer == ITUNES)) {
        return [itunes currentTrack];
    } else if (displayPlayer == SPOTIFY  || (displayPlayer == ANY && currentPlayer == SPOTIFY)) {
        return [spotify currentTrack];
    } else {
        assert(NO);
    }
}

- (NSString*) album {
    if ([self player] == NONE || [self state] == STOP) {
        return @"";
    }
    return [[self getCurrentTrack] album];
}

- (NSString*) artist {
    if ([self player] == NONE || [self state] == STOP) {
        return @"";
    }
    return [[self getCurrentTrack] artist];
}

- (NSString*) name {
    if ([self player] == NONE || [self state] == STOP) {
        return @"";
    }
    return [[self getCurrentTrack] name];
}

- (NSInteger) trackNumber {
    if ([self player] == NONE || [self state] == STOP) {
        return 0;
    }
    return [[self getCurrentTrack] trackNumber];
}

@end
