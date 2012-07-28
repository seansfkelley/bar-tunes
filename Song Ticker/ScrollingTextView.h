//
//  ScrollingTextView.h
//  Song Ticker
//
//  Created by Sean Kelley on 7/20/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "FormatWindowView.h"

@interface ScrollingTextView : NSView <NSMenuDelegate> {
    IBOutlet NSMenuItem *showIconsMenuItem;
    IBOutlet NSMenuItem *showPauseTextMenuItem;
    
    BOOL menuVisible;
    
    NSMutableDictionary *drawStringAttributes;
    
    NSTimer *timer;
    BOOL scrolling;
    BOOL scrollLeft;
    int scrollMaxOffset;
    float scrollCurrentOffset;
    
    const NSDictionary *imageDict;
    NSImage *currentImage;
}

- (void) clear;

@property (nonatomic) NSString *text;
@property (nonatomic) PlayerState state;
@property NSStatusItem *statusItem;
@property FormatWindowView *formatWindow;

@end
