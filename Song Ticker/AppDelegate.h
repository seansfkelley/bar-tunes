//
//  AppDelegate.h
//  Song Ticker
//
//  Created by Sean Kelley on 7/19/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "iTunes.h"
#import "Spotify.h"
#import "ScrollingTextView.h"
#import "SongMetadataTokenDelegate.h"

@interface AppDelegate : NSObject <NSApplicationDelegate> {
    IBOutlet NSMenu *statusMenu;
    IBOutlet NSTextField *formatField;
    NSString *formatString;
    IBOutlet NSWindow *formatWindow;
    ScrollingTextView *scrollText;
    
    iTunesApplication *itunes;
    SpotifyApplication *spotify;
    
    IBOutlet NSMenuItem *itunesMenuItem;
    IBOutlet NSMenuItem *spotifyMenuItem;
    IBOutlet NSMenuItem *anyPlayerMenuItem;
    
    id currentPlayer;
}

- (IBAction) bringFormatWindowToFront:(id)sender;
- (IBAction) closeWindowAndSetFormatString:(id)sender;

- (IBAction) setWatchItunes:(id)sender;
- (IBAction) setWatchSpotify:(id)sender;
- (IBAction) setWatchAny:(id)sender;

- (IBAction) quitApplication:(id)sender;

@end

/*
To do:
 selecting a player should NOT open the player if it is closed, instead say the player is closed (with icon)
 need to listen to NSWorkspace notifications for opening/closing iTunes? [+set variable appropriately]
 scroll while menu is selected?
 allow option to show icon on left or right
 icon
    stopped
    no player found [add enum]
 fade at edges?
 force to be always leftmost
 menu options
    set itunes/spotify/both
    [alternate] show icon on [left/right]
    slider: scroll speed (?)
    checkbox: show text when paused
    checkbox: scroll around v. scroll side-to-side
    quit
 spotify support
    what notifications does it publish?
    incorporate the header
 what's the CPU usage like? unreasonable? at least it doesn't use the dedicated GPU
 scroll speed constant, or a function of the length of the text?
 app icon
 save format string/app selections
 refactor to take menu item stuff out of app delegate? have the menu item manager call back to the ap delegate instead
*/