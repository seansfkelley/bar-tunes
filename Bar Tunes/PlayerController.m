#import "PlayerController.h"

@implementation PlayerController

@synthesize model;

NSString *itunesNoteName = @"com.apple.iTunes.playerInfo";
NSString *spotifyNoteName = @"com.spotify.client.PlaybackStateChanged";

- (PlayerController*) init {
    self =[super init];
    [[NSDistributedNotificationCenter defaultCenter] addObserver:self
                                                        selector:@selector(playerStateChangeNotification:)
                                                            name:itunesNoteName
                                                          object:nil];
    [[NSDistributedNotificationCenter defaultCenter] addObserver:self
                                                        selector:@selector(playerStateChangeNotification:)
                                                            name:spotifyNoteName
                                                          object:nil];
    [[[NSWorkspace sharedWorkspace] notificationCenter] addObserver:self
                                                           selector:@selector(playerTerminateNotification:)
                                                               name:NSWorkspaceDidTerminateApplicationNotification
                                                             object:nil];
    return self;
}

- (void) playerStateChangeNotification:(NSNotification*)note {
    // Both iTunes and Spotify have a Player State -> Playing in their userInfo.
    NSString *state = [[note userInfo] objectForKey:@"Player State"];
    NSString *player = [note name];
    if ([state isEqualToString:@"Playing"]) {
        if ([player isEqualToString:itunesNoteName]) {
            [model setCurrentPlayer:ITUNES];
        } else if ([player isEqualToString:spotifyNoteName]) {
            [model setCurrentPlayer:SPOTIFY];
        } else {
            assert(NO);
        }
    } else if ([state isEqualToString:@"Paused"] || [state isEqualToString:@"Stopped"]) {
        if ([player isEqualToString:itunesNoteName] && [model stateFor:SPOTIFY] == PLAY) {
            [model setCurrentPlayer:SPOTIFY];
        } else if ([player isEqualToString:spotifyNoteName] && [model stateFor:ITUNES] == PLAY) {
            [model setCurrentPlayer:ITUNES];
        }
    }
    
    if ([player isEqualToString:itunesNoteName]) {
        [model copyInfoFrom:[note userInfo] for:ITUNES];
    } else if ([player isEqualToString:spotifyNoteName]) {
        [model copyInfoFrom:[note userInfo] for:SPOTIFY];
    }
}

- (void) playerTerminateNotification:(NSNotification*)note {
    NSString *name = [[note userInfo] objectForKey:@"NSApplicationName"];
    if ([name isEqualToString:@"iTunes"]) {
        [model playerExit:ITUNES];
    } else if ([name isEqualToString:@"Spotify"]) {
        [model playerExit:SPOTIFY];
    }
}

- (void) printNotification:(NSNotification*)note {
    NSString *object = [note object];
    NSString *name = [note name];
    NSDictionary *userInfo = [note userInfo];
    NSLog(@"<%p>%s: object: %@ name: %@ userInfo: %@", self, __PRETTY_FUNCTION__, object, name, userInfo);
}

@end
