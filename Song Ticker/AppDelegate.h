//
//  AppDelegate.h
//  Song Ticker
//
//  Created by Sean Kelley on 7/19/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

@class MenuHandler;
@class FormatWindowView;

#import <Cocoa/Cocoa.h>
#import "iTunes.h"
#import "Spotify.h"
#import "MenuHandler.h"
#import "ScrollingTextView.h"
#import "FormatWindowView.h"
#import "FormatStringModel.h"
#import "NSStatusBar+Undocumented.h"

@class MenuHandler;
@class FormatWindowView;
@class ScrollingTextView;

@interface AppDelegate : NSObject <NSApplicationDelegate> {
    IBOutlet MenuHandler *menuHandler;
    IBOutlet ScrollingTextView *scrollText;
    
    IBOutlet FormatWindowView *formatView;
    FormatStringModel *formatModel;
    
    iTunesApplication *itunes;
    SpotifyApplication *spotify;
}

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
 DO ACTUAL MVC IT SHOULDNT BE THAT HARD.
    multiple models for switching between players? or one model that is changed when the player changes?
 
 menu options
    slider: scroll speed (?)
    scroll type
        circular
        bounce
        never (truncate)
 buttons in display should replace selection if any, else append

 app icon
 support undo for editing format string?
 remove stupid header comments

Questions:
 how to handle crash/force-quit of application we're listening to?
 when and why is itunes being kept open?
 scroll while menu is selected?
 scroll speed:
    constant?
    function of length?
    user selected?
    combination of user selected/function of length?
*/