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
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    showIcons = [defaults boolForKey:DEFAULTS_KEY_SHOW_ICONS];
    showPauseText = [defaults boolForKey:DEFAULTS_KEY_SHOW_PAUSE_TEXT];
    
    return self;
}

- (void) awakeFromNib {
    [showIconsMenuItem setState: showIcons ? NSOnState : NSOffState];
    [showPauseTextMenuItem setState: showPauseText ? NSOnState : NSOffState];
}

- (void) setText:(NSString*)t {
    BOOL textChanged = ![t isEqualToString:text];
    NSSize stringSize = [t sizeWithAttributes:drawStringAttributes];
    [timer invalidate];
    
    if ([t isEqualToString:@""] || (!showPauseText && [self state] == PAUSE)) {
        scrolling = NO;
        [self setFrame:NSMakeRect(0, 0, IMAGE_WIDTH, [self frame].size.height)];
    } else if (stringSize.width <= MAX_STATIC_WIDTH) {
        scrolling = NO;
        [self setFrame:NSMakeRect(0, 0, stringSize.width +
                                        (showIcons ? IMAGE_WIDTH : 0) +
                                        EXTRA_SPACE_STATIC * 2, [self frame].size.height)];
    } else {
        timer = [NSTimer scheduledTimerWithTimeInterval:INTERVAL
                                                 target:self
                                               selector:@selector(refresh)
                                               userInfo:nil
                                                repeats:YES];
        // More than just a state change.
        if (!scrolling || textChanged) {
            scrollCurrentOffset = 0;
            scrollLeft = YES;
        }
        scrollMaxOffset = (stringSize.width) - MAX_SCROLLING_WIDTH;
        scrolling = YES;
        [self setFrame:NSMakeRect(0, 0, MAX_SCROLLING_WIDTH + (showIcons ? IMAGE_WIDTH : 0), [self frame].size.height)];
    }
    text = t;
    [self setNeedsDisplay:YES];
    
    if (textChanged) {
        [[statusItem menu] cancelTracking];
    }
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

    if (showPauseText || state != PAUSE) {
        if (scrolling) {
            scrollCurrentOffset += scrollLeft ? SCROLL_SPEED : -SCROLL_SPEED;
            if (scrollCurrentOffset >= scrollMaxOffset + EXTRA_SPACE_SCROLL || scrollCurrentOffset <= -EXTRA_SPACE_SCROLL) {
                scrollLeft = !scrollLeft;
            }
            NSPoint centerPoint;
            centerPoint.x = -scrollCurrentOffset + (showIcons ? IMAGE_WIDTH : 0);
            centerPoint.y = VERTICAL_OFFSET;
            [text drawAtPoint:centerPoint withAttributes:drawStringAttributes];
            [self setNeedsDisplay:YES];
        } else if (![text isEqualToString:@""]) {
            NSPoint centerPoint;
            centerPoint.x = (showIcons ? IMAGE_WIDTH : 0) + EXTRA_SPACE_STATIC;
            centerPoint.y = VERTICAL_OFFSET;
            [text drawAtPoint:centerPoint withAttributes:drawStringAttributes];
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
    if (state == STOP || showIcons) {
        [[imageDict objectForKey:filename] drawAtPoint:NSZeroPoint fromRect:NSZeroRect operation:NSCompositeCopy fraction:1];
    } else if (state == PAUSE && !showPauseText) {
        if (menuVisible) {
            [[imageDict objectForKey:@"noteHi"] drawAtPoint:NSZeroPoint fromRect:NSZeroRect operation:NSCompositeCopy fraction:1];
        } else {
            [[imageDict objectForKey:@"note"] drawAtPoint:NSZeroPoint fromRect:NSZeroRect operation:NSCompositeCopy fraction:1];
        }
    }
}

- (void) setState:(PlayerState)ps {
    state = ps;
    if (state == PAUSE && !showPauseText) {
        [self clear];
    }
}

self setText:[self text]];
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
