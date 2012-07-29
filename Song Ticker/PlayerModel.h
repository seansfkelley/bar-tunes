//
//  PlayerControlModel.h
//  Song Ticker
//
//  Created by Sean Kelley on 7/28/12.
//
//

#import <Foundation/Foundation.h>
#import "iTunes.h"
#import "Spotify.h"

@interface PlayerModel : NSObject {
    Player displayPlayer;
    Player currentPlayer;
    
    BOOL initialized;
}

@property iTunesApplication *itunes;
@property SpotifyApplication *spotify;

@property (nonatomic, readonly) PlayerState itunesPlayerState;
@property (nonatomic, readonly) PlayerState spotifyPlayerState;

// Set which player we would like to see, or ANY (to use whichever player is currently active).
- (void) setDisplayPlayer:(Player)p;

// Set which player is considered the currently active player.
- (void) setCurrentPlayer:(Player)p;

// Get which player we are to display (NONE is a valid return value; but ANY is not) the
// returned player is not necessarily currently running.
- (Player) player;

// Get the state of the player. Returns STOP if there is no player.
- (PlayerState) state;

- (void) initialize;
- (void) firePlayerInfoChange;

- (NSString*) album;
- (NSString*) artist;
- (NSString*) name;
- (NSInteger) trackNumber;

@end
