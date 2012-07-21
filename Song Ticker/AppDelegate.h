//
//  AppDelegate.h
//  Song Ticker
//
//  Created by Sean Kelley on 7/19/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "ScrollingTextView.h"

@interface AppDelegate : NSObject <NSApplicationDelegate> {
    NSWindow *window;
    IBOutlet NSMenu *statusMenu;
    IBOutlet NSMenuItem *quitItem;
    ScrollingTextView *scrollText;
}

- (IBAction) quitApplication:(id)sender;

@property (assign) IBOutlet NSWindow *window;

@end

/*
To do:
 don't flip the text back to the beginning if only the play/pause state is changed (do this through actual state changes, not text changes -- state = icon)
 draw icon on left that doesn't scroll so there is a visual left border
    play 
    pause
    no player found
 fade at edges?
 force to be always leftmost
 menu options
    set format string
    set itunes/spotify/both
    slider: scroll speed
    checkbox: show text when paused
    quit
 get itunes state at startup so something is shown, or just icon
 spotify support
 what's the CPU usage like? unreasonable? at least it doesn't use the dedicated GPU
 scroll speed constant, or a function of the length of the text?
 fiddle with parameters
 app icon
*/