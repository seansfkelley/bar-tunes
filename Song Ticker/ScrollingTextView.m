//
//  ScrollingTextView.m
//  Song Ticker
//
//  Created by Sean Kelley on 7/20/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ScrollingTextView.h"

@implementation ScrollingTextView

@synthesize text;
@synthesize state;
@synthesize statusItem;

BOOL menuVisible = NO;

const int EXTRA_SPACING = 20;
const int VERTICAL_OFFSET = 3;
const int MAX_STATIC_WIDTH = 300;
const int MAX_SCROLLING_WIDTH = 250;

const float SCROLL_SPEED = 0.33;
const float INTERVAL = 1 / 30.0; // 30 FPS

- (id) init {
    self = [super init];
    drawStringAttributes = [[NSMutableDictionary alloc] init];
	[drawStringAttributes setValue:[NSFont menuBarFontOfSize:11.0] forKey:NSFontAttributeName];
    return self;
}

- (void) setText:(NSString*)t {
    text = t;
    stringSize = [text sizeWithAttributes:drawStringAttributes];
    [timer invalidate];
    if (stringSize.width + EXTRA_SPACING <= 300) {
        scrolling = NO;
        [self setFrame:NSMakeRect(0, 0, stringSize.width + EXTRA_SPACING, [self frame].size.height)];
    } else {
        scrolling = YES;
        timer = [NSTimer scheduledTimerWithTimeInterval:INTERVAL
                                                 target:self
                                               selector:@selector(refresh)
                                               userInfo:nil
                                                repeats:YES];
        scrollLeft = YES;
        scrollMaxOffset = (stringSize.width) - 250;
        scrollCurrentOffset = 0;
        [self setFrame:NSMakeRect(0, 0, 250, [self frame].size.height)];
    }
    [self refresh];
}

- (void) drawRect:(NSRect)dirtyRect {
    [self refresh];
}

- (void) refresh {
    [statusItem drawStatusBarBackgroundInRect:[self bounds] withHighlight:menuVisible];
    if (menuVisible) {
        [drawStringAttributes setValue:[NSColor selectedMenuItemTextColor] forKey:NSForegroundColorAttributeName];
    } else {
        [drawStringAttributes setValue:[NSColor controlTextColor] forKey:NSForegroundColorAttributeName];
    }
    
    if (scrolling) {
        scrollCurrentOffset += scrollLeft ? SCROLL_SPEED : -SCROLL_SPEED;
        if (scrollCurrentOffset >= scrollMaxOffset + EXTRA_SPACING || scrollCurrentOffset <= -EXTRA_SPACING) {
            scrollLeft = !scrollLeft;
        }
        NSPoint centerPoint;
        centerPoint.x = -scrollCurrentOffset;
        centerPoint.y = VERTICAL_OFFSET;
        [text drawAtPoint:centerPoint withAttributes:drawStringAttributes];
        [self setNeedsDisplay:YES];
    } else {
        NSPoint centerPoint;
        centerPoint.x = [self bounds].size.width / 2 - (stringSize.width / 2);
        centerPoint.y = VERTICAL_OFFSET;
        [text drawAtPoint:centerPoint withAttributes:drawStringAttributes];
    }
}

- (void) mouseDown:(NSEvent*)event {
    [[statusItem menu] setDelegate:self];
    [statusItem popUpStatusItemMenu:[statusItem menu]];
    [self setNeedsDisplay:YES];
}

- (void) rightMouseDown:(NSEvent*)event {
    [self mouseDown:event];
}

- (void) menuWillOpen:(NSMenu*)menu {
    menuVisible = YES;
    [self setNeedsDisplay:YES];
}

- (void) menuDidClose:(NSMenu *)menu {
    menuVisible = NO;
    [[statusItem menu] setDelegate:nil];
    [self setNeedsDisplay:YES];
}

@end
