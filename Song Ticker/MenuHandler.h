//
//  MenuHandler.h
//  Song Ticker
//
//  Created by Sean Kelley on 7/23/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

@class AppDelegate;

#import <Foundation/Foundation.h>
#import "AppDelegate.h"

@interface MenuHandler : NSMenu {
    IBOutlet NSMenuItem *itunesMenuItem;
    IBOutlet NSMenuItem *spotifyMenuItem;
    IBOutlet NSMenuItem *anyPlayerMenuItem;
}

@property (nonatomic) AppDelegate *appDelegate;

- (void) setWatch:(Player)p;
- (IBAction) setWatchItunes:(id)sender;
- (IBAction) setWatchSpotify:(id)sender;
- (IBAction) setWatchAny:(id)sender;
- (void) setWatchAnyCurrentPlayer:(Player)p;

@end
