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
@synthesize formatWindow;

const int IMAGE_WIDTH = 18;
const int EXTRA_SPACE_SCROLL = 20;
const int EXTRA_SPACE_STATIC = 3;
const int VERTICAL_OFFSET = 4;
const int MAX_STATIC_WIDTH = 300;
const int MAX_SCROLLING_WIDTH = 250;

const float SCROLL_SPEED = 0.33;
const float INTERVAL = 1 / 30.0; // 30 FPS

- (id) init {
    self = [super init];
    drawStringAttributes = [[NSMutableDictionary alloc] init];
	[drawStringAttributes setValue:[NSFont menuBarFontOfSize:11.0] forKey:NSFontAttributeName];
    
    imageDict = [[NSDictionary alloc] initWithObjectsAndKeys:[NSImage imageNamed:@"play"], @"play",
                                                             [NSImage imageNamed:@"playHighlight"], @"playHi",
                                                             [NSImage imageNamed:@"pause"], @"pause",
                                                             [NSImage imageNamed:@"pauseHighlight"], @"pauseHi",
                                                             [NSImage imageNamed:@"note"], @"note",
                                                             [NSImage imageNamed:@"noteHighlight"], @"noteHi",
                                                             nil];
    menuVisible = NO;
    scrolling = NO;
    
    return self;
}

- (void) setText:(NSString*)t {
    NSSize stringSize = [t sizeWithAttributes:drawStringAttributes];
    [timer invalidate];
    if ([t isEqualToString:@""]) {
        scrolling = NO;
        [self setFrame:NSMakeRect(0, 0, IMAGE_WIDTH, [self frame].size.height)];
    } else if (stringSize.width <= MAX_STATIC_WIDTH) {
        scrolling = NO;
        [self setFrame:NSMakeRect(0, 0, stringSize.width + IMAGE_WIDTH + EXTRA_SPACE_STATIC * 2, [self frame].size.height)];
    } else {
        
        timer = [NSTimer scheduledTimerWithTimeInterval:INTERVAL
                                                 target:self
                                               selector:@selector(refresh)
                                               userInfo:nil
                                                repeats:YES];
        // Only a state change.
        if (!scrolling || ![t isEqualToString:text]) {
            scrollCurrentOffset = 0;
            scrollLeft = YES;
        }
        scrollMaxOffset = (stringSize.width) - MAX_SCROLLING_WIDTH;
        scrolling = YES;
        [self setFrame:NSMakeRect(0, 0, MAX_SCROLLING_WIDTH + IMAGE_WIDTH, [self frame].size.height)];
    }
    text = t;
    [self setNeedsDisplay:YES];
}

- (void) clear {
    [self setText:@""];
    [self setNeedsDisplay:YES];
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
        if (scrollCurrentOffset >= scrollMaxOffset + EXTRA_SPACE_SCROLL || scrollCurrentOffset <= -EXTRA_SPACE_SCROLL) {
            scrollLeft = !scrollLeft;
        }
        NSPoint centerPoint;
        centerPoint.x = -scrollCurrentOffset + IMAGE_WIDTH;
        centerPoint.y = VERTICAL_OFFSET;
        [text drawAtPoint:centerPoint withAttributes:drawStringAttributes];
        [self setNeedsDisplay:YES];
    } else {
        NSPoint centerPoint;
        centerPoint.x = IMAGE_WIDTH + EXTRA_SPACE_STATIC;
        centerPoint.y = VERTICAL_OFFSET;
        [text drawAtPoint:centerPoint withAttributes:drawStringAttributes];
    };
    
    NSMutableString *filename;
    if (state == PLAY) {
        filename = [[NSMutableString alloc] initWithString:@"play"];
    } else if (state == PAUSE) {
        filename = [[NSMutableString alloc] initWithString:@"pause"];
    } else {
        filename = [[NSMutableString alloc] initWithString:@"note"];
    }
    if (menuVisible) {
        [filename appendString:@"Hi"];
    }
    [[imageDict objectForKey:filename] drawAtPoint:NSZeroPoint fromRect:NSZeroRect operation:NSCompositeCopy fraction:1];
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
    [formatWindow closeWindowWithoutSettingString:self];
    [self setNeedsDisplay:YES];
}

- (void) menuDidClose:(NSMenu *)menu {
    menuVisible = NO;
    [[statusItem menu] setDelegate:nil];
    [self setNeedsDisplay:YES];
}

@end
