#import <Foundation/Foundation.h>
#import "iTunes.h"
#import "Spotify.h"
#import "SinglePlayerModel.h"

@interface UnifiedPlayerModel : NSObject {
    SinglePlayerModel *itunesModel;
    SinglePlayerModel *spotifyModel;
    
    Player displayPlayer;
    Player currentPlayer;
}

// Set which player we would like to see, or ANY (to use whichever player is currently active).
- (void) setDisplayPlayer:(Player)p;

// Set which player is considered the currently active player.
- (void) setCurrentPlayer:(Player)p;

// Get which player we are to display (NONE is a valid return value; but ANY is not) the
// returned player is not necessarily currently running.
- (Player) player;

// Get the state of the player. Returns STOP if there is no player.
- (PlayerState) state;

// Get the state for a particular player.
- (PlayerState) stateFor:(Player)p;

- (void) copyInfoFrom:(NSDictionary*)info for:(Player)p;

- (NSString*) album;
- (NSString*) artist;
- (NSString*) name;
- (NSString*) trackNumber;

@end
