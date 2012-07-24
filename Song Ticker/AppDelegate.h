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

typedef enum player {
    ITUNES,
    SPOTIFY,
    ANY
} Player;

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

@end

/*
To do:
 how to handle crash/force-quit of application we're listening to?
 why is itunes being kept open?
 format popup should 
    listen to esc as cancel
    be closed when the menu is opened
 scroll while menu is selected?
 fade at edges?
 force to be always leftmost
 menu options
    [alternate] show icon on [left/right]
    slider: scroll speed (?)
    checkbox: show text when paused
    checkbox: scroll around v. scroll side-to-side
 what's the CPU usage like? unreasonable? at least it doesn't use the dedicated GPU
 scroll speed constant, or a function of the length of the text?
 app icon
 save format string/app selections
 MVC separation -- controllers = views = models now (format, menu handlers)
*/