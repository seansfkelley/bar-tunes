//
//  ScrollingTextView.h
//  Song Ticker
//
//  Created by Sean Kelley on 7/20/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>

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

typedef enum playerState
{
    PLAY,
    PAUSE,
    STOP
} PlayerState;

- (void) clear;

@property (nonatomic) NSString *text;
@property PlayerState state;
@property NSStatusItem *statusItem;

@end
