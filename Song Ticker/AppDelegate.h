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

@class MenuHandler;
@class FormatWindowHandler;
@class ScrollingTextView;

@interface AppDelegate : NSObject <NSApplicationDelegate> {
    IBOutlet MenuHandler *menuHandler;
    IBOutlet FormatWindowHandler *formatHandler;
    
    ScrollingTextView *scrollText;
    
    iTunesApplication *itunes;
    SpotifyApplication *spotify;
    
    SBApplication *currentPlayer;
}

@property (nonatomic) NSString *formatString;

- (IBAction) quitApplication:(id)sender;
- (void) setCurrentPlayer:(Player)p;
- (Player) getCurrentPlayer;

@end

/*
To do (ordered by approximate priority):
 implement any-player option (what is appropriate logic for this: last player to send play notification [that is NOT overridden by a pause]?)
 force to be always leftmost
 help with interpolation
    help button with popup/make text appear
    permanent small text underneath text field
 menu options
    [alternate] show icon on [left/right]
    slider: scroll speed (?)
    checkbox: show text when paused
    checkbox: scroll around v. scroll side-to-side
 shrink menubar icon
 MVC separation -- controllers = views = models now (format, menu handlers)
 app icon
 remove deprecated call from MAAttachedWindow

Questions:
 what's the CPU usage like? unreasonable? at least it doesn't use the dedicated GPU
 how to handle crash/force-quit of application we're listening to?
 why is itunes being kept open?
 scroll while menu is selected?
 need so much extra space while scrolling?
 scroll speed constant, or a function of the length of the text
*/