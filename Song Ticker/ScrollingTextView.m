//
//  ScrollingTextView.m
//  Song Ticker
//
//  Created by Sean Kelley on 7/20/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ScrollingTextView.h"

@implementation ScrollingTextView

@synthesize model;
@synthesize statusItem;
@synthesize formatController;

const int IMAGE_WIDTH = 18;
const int EXTRA_SPACE_SCROLL = 16;
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

- (void) drawRect:(NSRect)dirtyRect {
    [self refresh];
}

// Triggered by a change in state.
- (void) resize:(ChangeType)c {
    NSString *t = [model text];
    NSSize stringSize = [t sizeWithAttributes:drawStringAttributes];
    [timer invalidate];
    
    if ([t isEqualToString:@""] || (![model showPauseText] && [model state] == PAUSE)) {
        scrolling = NO;
        [self setFrame:NSMakeRect(0, 0, IMAGE_WIDTH, [self frame].size.height)];
    } else if (stringSize.width <= MAX_STATIC_WIDTH) {
        scrolling = NO;
        [self setFrame:NSMakeRect(0, 0, stringSize.width +
                                  ([model showIcons] ? IMAGE_WIDTH : 0) +
                                  EXTRA_SPACE_STATIC * 2, [self frame].size.height)];
    } else {
        timer = [NSTimer scheduledTimerWithTimeInterval:INTERVAL
                                                 target:self
                                               selector:@selector(refresh)
                                               userInfo:nil
                                                repeats:YES];
        // More than just a state change.
        if (!scrolling || c == DISPLAY_TEXT) {
            scrollCurrentOffset = 0;
            scrollLeft = YES;
        }
        scrollMaxOffset = (stringSize.width) - MAX_SCROLLING_WIDTH;
        scrolling = YES;
        [self setFrame:NSMakeRect(0, 0, MAX_SCROLLING_WIDTH + ([model showIcons] ? IMAGE_WIDTH : 0), [self frame].size.height)];
    }
    
    if (c == DISPLAY_TEXT) {
        [[statusItem menu] cancelTracking];
    }
    [self setNeedsDisplay:YES];
}

- (void) refresh {
    [statusItem drawStatusBarBackgroundInRect:[self bounds] withHighlight:menuVisible];
    if (menuVisible) {
        [drawStringAttributes setValue:[NSColor selectedMenuItemTextColor] forKey:NSForegroundColorAttributeName];
    } else {
        [drawStringAttributes setValue:[NSColor controlTextColor] forKey:NSForegroundColorAttributeName];
    }

    PlayerState state = [model state];
    if ([model showPauseText] || state != PAUSE) {
        NSString *t = [model text];
        if (scrolling) {
            scrollCurrentOffset += scrollLeft ? SCROLL_SPEED : -SCROLL_SPEED;
            if (scrollCurrentOffset >= scrollMaxOffset + EXTRA_SPACE_SCROLL || scrollCurrentOffset <= -EXTRA_SPACE_SCROLL) {
                scrollLeft = !scrollLeft;
            }
            NSPoint centerPoint;
            centerPoint.x = -scrollCurrentOffset + ([model showIcons] ? IMAGE_WIDTH : 0);
            centerPoint.y = VERTICAL_OFFSET;
            [t drawAtPoint:centerPoint withAttributes:drawStringAttributes];
            [self setNeedsDisplay:YES];
        } else if (![t isEqualToString:@""]) {
            NSPoint centerPoint;
            centerPoint.x = ([model showIcons] ? IMAGE_WIDTH : 0) + EXTRA_SPACE_STATIC;
            centerPoint.y = VERTICAL_OFFSET;
            [t drawAtPoint:centerPoint withAttributes:drawStringAttributes];
        }
    }
    
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
    if (state == STOP || [model showIcons]) {
        [[imageDict objectForKey:filename] drawAtPoint:NSZeroPoint fromRect:NSZeroRect operation:NSCompositeCopy fraction:1];
    } else if (state == PAUSE && ![model showPauseText]) {
        if (menuVisible) {
            [[imageDict objectForKey:@"noteHi"] drawAtPoint:NSZeroPoint fromRect:NSZeroRect operation:NSCompositeCopy fraction:1];
        } else {
            [[imageDict objectForKey:@"note"] drawAtPoint:NSZeroPoint fromRect:NSZeroRect operation:NSCompositeCopy fraction:1];
        }
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
    [formatController cancel:menu];
    [self setNeedsDisplay:YES];
}

- (void) menuDidClose:(NSMenu *)menu {
    menuVisible = NO;
    [[statusItem menu] setDelegate:nil];
    [self setNeedsDisplay:YES];
}

- (void) observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    ChangeType c;
    if ([keyPath isEqualToString:@"text"]) {
        c = DISPLAY_TEXT;
    } else if ([keyPath isEqualToString:@"state"]) {
        c = PLAYER_STATE;
    }
    [self resize:c];
}


@end
