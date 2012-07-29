//
//  AppDelegate.h
//  Song Ticker
//
//  Created by Sean Kelley on 7/19/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

@class PlayerControlView;
@class FormatStringModel;
@class FormatStringView;
@class FormatStringController;
@class DisplayModel;
@class ScrollingTextView;
@class DisplayController;

#import <Cocoa/Cocoa.h>
#import "iTunes.h"
#import "Spotify.h"
#import "FormatStringPackage.h"
#import "DisplayPackage.h"
#import "PlayerPackage.h"
#import "NSStatusBar+Undocumented.h"

@interface AppDelegate : NSObject <NSApplicationDelegate> {
    FormatStringModel *formatModel;
    IBOutlet FormatStringView *formatView;
    IBOutlet FormatStringController *formatController;
    
    DisplayModel *displayModel;
    IBOutlet ScrollingTextView *displayView;
    IBOutlet DisplayController *displayController;
    
    PlayerModel *playerModel;
    IBOutlet PlayerControlView *playerControlView;
    IBOutlet PlayerController *playerController;
}

- (IBAction) quitApplication:(id)sender;

@end

/*
To do (ordered by approximate priority):
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