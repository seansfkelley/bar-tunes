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
    IBOutlet ScrollingTextView *scrollText;
    
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
    [alternate] scroll around v. scroll side-to-side [or just permanently switch?]
 buttons in display should replace selection, else append and deselect

 DO ACTUAL MVC IT SHOULDNT BE THAT HARD.
    multiple models for switching between players? or one model that is changed when the player changes?
 app icon

Questions:
 how to handle crash/force-quit of application we're listening to?
 only allow one instance of each format string item?
 why is itunes being kept open?
 scroll while menu is selected?
 scroll speed constant, or a function of the length of the text?
*/