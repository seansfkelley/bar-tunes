//
//  MenuHandler.h
//  Song Ticker
//
//  Created by Sean Kelley on 7/23/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PlayerModel.h"

@interface PlayerControlView : NSMenu {
    IBOutlet NSMenuItem *itunesMenuItem;
    IBOutlet NSMenuItem *spotifyMenuItem;
    IBOutlet NSMenuItem *anyPlayerMenuItem;
}

@property PlayerModel *model;

- (void) setWatch:(Player)p;
- (IBAction) setWatchItunes:(id)sender;
- (IBAction) setWatchSpotify:(id)sender;
- (IBAction) setWatchAny:(id)sender;

@end
