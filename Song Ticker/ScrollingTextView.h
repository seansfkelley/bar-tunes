//
//  ScrollingTextView.h
//  Song Ticker
//
//  Created by Sean Kelley on 7/20/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface ScrollingTextView : NSView <NSMenuDelegate> {
    NSStatusItem *statusItem;
    NSTimer *timer;
    NSMutableDictionary *drawStringAttributes;
    NSSize stringSize;
    BOOL scrolling;
    BOOL scrollLeft;
    int scrollMaxOffset;
    float scrollCurrentOffset;
}

@property (nonatomic) NSString *text;
@property NSString *state;
@property NSStatusItem *statusItem;

@end
