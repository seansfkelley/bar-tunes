//
//  ScrollingTextView.h
//  Song Ticker
//
//  Created by Sean Kelley on 7/20/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "FormatWindowHandler.h"

@interface ScrollingTextView : NSView <NSMenuDelegate> {
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
@property PlayerState state;
@property NSStatusItem *statusItem;
@property FormatWindowHandler *formatWindow;

@end
