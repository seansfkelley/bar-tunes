#import "UnifiedPlayerModel.h"

@implementation UnifiedPlayerModel

- (UnifiedPlayerModel*) init {
    self = [super init];

    itunesModel = [[SinglePlayerModel alloc] init];
    spotifyModel = [[SinglePlayerModel alloc] init];
    
    [self initializePlayerStates];
    
    if ([itunesModel state] == PLAY) {
        currentPlayer = ITUNES;
    } else if ([spotifyModel state] == PLAY) {
        currentPlayer = SPOTIFY;
    } else if ([itunesModel state] == PAUSE) {
        currentPlayer = ITUNES;
    } else if ([spotifyModel state] == PAUSE) {
        currentPlayer = SPOTIFY;
    } else {
        currentPlayer = NONE;
    }
    
    displayPlayer = ANY;
    
    return self;
}

- (PlayerState) state {
    if (displayPlayer == ITUNES || (displayPlayer == ANY && currentPlayer == ITUNES)) {
        return [itunesModel state];
    } else if (displayPlayer == SPOTIFY  || (displayPlayer == ANY && currentPlayer == SPOTIFY)) {
        return [spotifyModel state];
    } else if (displayPlayer == ANY && currentPlayer == NONE) {
        return STOP;
    } else {
        assert(NO);
    }
}

- (PlayerState) stateFor:(Player)p {
    if (p == ITUNES) {
        return [itunesModel state];
    } else if (p == SPOTIFY) {
        return [spotifyModel state];
    } else {
        assert(NO);
    }
}

- (void) setState:(PlayerState)s for:(Player)p {
    if (displayPlayer == p || (displayPlayer == ANY && currentPlayer == p)) {
        [self willChangeValueForKey:@"state"];
    }
    if (p == ITUNES) {
        [itunesModel setState:s];
    } else if (p == SPOTIFY) {
        [spotifyModel setState:s];
    } else {
        assert(NO);
    }
    if (displayPlayer == p || (displayPlayer == ANY && currentPlayer == p)) {
        [self didChangeValueForKey:@"state"];
    }
}

- (void) initializePlayerStates {
    iTunesApplication *itunes = [SBApplication applicationWithBundleIdentifier:@"com.apple.iTunes"];
    SpotifyApplication *spotify = [SBApplication applicationWithBundleIdentifier:@"com.spotify.client"];
    
    if (![itunes isRunning]) {
        [itunesModel setState:STOP];
    } else {
        if ([itunes playerState] == iTunesEPlSPlaying) {
            [itunesModel setState:PLAY];
        } else if ([itunes playerState] == iTunesEPlSPaused) {
            [itunesModel setState:PAUSE];
        } else {
            [itunesModel setState:STOP];
        }
        iTunesTrack *track = [itunes currentTrack];
        [itunesModel setAlbum:[track album]];
        [itunesModel setArtist:[track artist]];
        [itunesModel setName:[track name]];
        [itunesModel setTrackNumber:[NSString stringWithFormat:@"%ld", [track trackNumber]]];
    }
    
    if (![spotify isRunning]) {
        [spotifyModel setState:STOP];
    } else {
        if ([spotify playerState] == SpotifyEPlSPlaying) {
            [spotifyModel setState:PLAY];
        } else if ([spotify playerState] == SpotifyEPlSPaused) {
            [spotifyModel setState:PAUSE];
        } else {
            [spotifyModel setState:STOP];
        }
        SpotifyTrack *track = [spotify currentTrack];
        [spotifyModel setAlbum:[track album]];
        [spotifyModel setArtist:[track artist]];
        [spotifyModel setName:[track name]];
        [spotifyModel setTrackNumber:[NSString stringWithFormat:@"%ld", [track trackNumber]]];
    }
}

- (void) setDisplayPlayer:(Player)p {
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
    if (displayPlayer == ANY) {
        return currentPlayer;
    }
    return displayPlayer;
}

- (void) playerExit:(Player)p {
    if (p == ITUNES) {
        [itunesModel playerExit];
    } else if (p == SPOTIFY) {
        [spotifyModel playerExit];
    } else {
        assert(NO);
    }
}

- (void) copyInfoFrom:(NSDictionary*)info for:(Player)p {
    [self willChangeValueForKey:@"player"];
    if (p == ITUNES) {
        [itunesModel copyInfoFrom:info];
    } else if (p == SPOTIFY) {
        [spotifyModel copyInfoFrom:info];
    } else {
        assert(NO);
    }
    [self didChangeValueForKey:@"player"];
}

- (NSString*) getProperty:(SEL)sel {
    if ([self player] == NONE || [self state] == STOP) {
        return @"";
    }
    if ([self player] == ITUNES) {
        return [itunesModel performSelector:sel];
    } else if ([self player] == SPOTIFY) {
        return [spotifyModel performSelector:sel];
    } else {
        assert(NO);
    }
}

- (NSString*) album {
    return [self getProperty:@selector(album)];
}

- (NSString*) artist {
    return [self getProperty:@selector(artist)];
}

- (NSString*) name {
    return [self getProperty:@selector(name)];
}

- (NSString*) trackNumber {
    return [self getProperty:@selector(trackNumber)];
}

@end
