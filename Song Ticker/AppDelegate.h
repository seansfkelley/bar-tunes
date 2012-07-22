//
//  AppDelegate.h
//  Song Ticker
//
//  Created by Sean Kelley on 7/19/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "iTunes.h"
#import "ScrollingTextView.h"
#import "SongMetadataTokenDelegate.h"

@interface AppDelegate : NSObject <NSApplicationDelegate> {
    IBOutlet NSMenu *statusMenu;
    IBOutlet NSTokenField *tokenField;
    IBOutlet NSWindow *formatWindow;
    iTunesApplication *itunes;
    ScrollingTextView *scrollText;
}

- (IBAction) bringFormatWindowToFront:(id)sender;
- (IBAction) closeWindowAndSetFormatString:(id)sender;
- (IBAction) quitApplication:(id)sender;

@property (readonly) iTunesApplication *itunes;

@end

/*
To do:
 need to listen to NSWorkspace notifications for opening/closing iTunes? [+set variable appropriately]
 show current settings for format string
    later: for now, just use specialized % formatting
    title, artist, album (album artist?) (track number?)
 draggable list of tokens?
 scroll while menu is selected?
 don't flip the text back to the beginning if only the play/pause state is changed (do this through actual state changes, not text changes -- state = icon)
 draw icon on left that doesn't scroll so there is a visual left border
    play 
    pause
    stopped
    no player found [add enum]
 fade at edges?
 force to be always leftmost
 menu options
    set format string
    set itunes/spotify/both
    slider: scroll speed (?)
    checkbox: show text when paused
    checkbox: scroll around v. scroll side-to-side
    quit
 spotify support
    what notifications does it publish?
    incorporate the header
 what's the CPU usage like? unreasonable? at least it doesn't use the dedicated GPU
 scroll speed constant, or a function of the length of the text?
 fiddle with parameters
 app icon
 
 refactor:
    move private members from scroll text out of header? (same for appdelegate)
    subclass NSStatusItem to support setText, etc., that it delegates to a ScrollText instance that it doesn't reveal
        can hide weird self-referential management (scroll text and status menu pointing to each other)
        can own the status enum; understand how to display state/text without having clients have to do so
    can format window be subclassed so it can do something similar for getting/setting the format strings without
        clients worrying about how they are stored/represented to the user?
    rename appdelegate
*/