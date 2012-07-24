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
    
    SBApplication *currentPlayer;
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
 popdown from menubar for setting format string? instead of full-fledged window
 need to listen to NSWorkspace notifications for opening/closing iTunes? [+set variable appropriately]
 scroll while menu is selected?
 icon
    stopped
    no player found
 state
    no player found
 fade at edges?
 force to be always leftmost
 menu options
    [alternate] show icon on [left/right]
    slider: scroll speed (?)
    checkbox: show text when paused
    checkbox: scroll around v. scroll side-to-side
    quit
 what's the CPU usage like? unreasonable? at least it doesn't use the dedicated GPU
 scroll speed constant, or a function of the length of the text?
 app icon
 save format string/app selections
 refactor to take menu item stuff out of app delegate? have the menu item manager call back to the ap delegate instead
*/