//
//  AppDelegate.h
//  Song Ticker
//
//  Created by Sean Kelley on 7/19/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

@class MenuHandler;
@class FormatWindowHandler;

#import <Cocoa/Cocoa.h>
#import "iTunes.h"
#import "Spotify.h"
#import "MenuHandler.h"
#import "ScrollingTextView.h"
#import "FormatWindowHandler.h"
#import "NSStatusBar+Undocumented.h"

@class MenuHandler;
@class FormatWindowHandler;
@class ScrollingTextView;

@interface AppDelegate : NSObject <NSApplicationDelegate> {
    IBOutlet MenuHandler *menuHandler;
    IBOutlet FormatWindowHandler *formatHandler;
    
    ScrollingTextView *scrollText;
    
    iTunesApplication *itunes;
    SpotifyApplication *spotify;
}

@property (nonatomic) NSString *formatString;

// Which player we are displaying, or ANY if the current player should be used.
@property (nonatomic) Player displayedPlayer;

// Which player is "current", i.e., was the last to play a song (preferring iTunes in the 
// event of a tie-break). Not necessarily the player being displayed; should be referenced
// when displayedPlayer is ANY.
@property Player currentPlayer;

- (IBAction) quitApplication:(id)sender;

@end

/*
To do (ordered by approximate priority):
 menu options
    slider: scroll speed (?)
    checkbox: show text when paused
    checkbox: show play/pause icons
    [alternate] scroll around v. scroll side-to-side [or just permanently switch?]
 buttons in display should replace selection, else append and deselect
 shrink menubar icon
 MVC separation -- controllers = views = models now (format, menu handlers)
 app icon
 remove deprecated call from MAAttachedWindow

Questions:
 how to handle crash/force-quit of application we're listening to?
 only allow one instance of each format string item?
 why is itunes being kept open?
 scroll while menu is selected?
 need so much extra space at edges while scrolling?
 drop amount of space needed by a few pixels?
 scroll speed constant, or a function of the length of the text?
*/