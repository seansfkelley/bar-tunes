#import "ScrollingTextView.h"

@implementation ScrollingTextView

@synthesize model;
@synthesize statusItem;

const int VERTICAL_OFFSET = 4;
const int IMAGE_WIDTH = 18;
const int IMAGE_HEIGHT = 22;

const int PX_BEFORE_SCROLLS = 16;
const int PX_BETWEEN_SCROLLS = 40;

const int EXTRA_SPACE_STATIC = 4;

const float SCROLL_SPEED = 0.5;
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
    scrolling = NO;
    return self;
}

- (void) drawRect:(NSRect)dirtyRect {
    [self refresh];
}

// Triggered by a change in state.
- (void) resize:(BOOL)textChanged {
    NSString *t = [model text];
    NSSize stringSize = [t sizeWithAttributes:drawStringAttributes];
    [timer invalidate];
    
    if ([t isEqualToString:@""] || (![model showPauseText] && [model state] == PAUSE) || [model state] == STOP) {
        scrolling = NO;
        [self setFrame:NSMakeRect(0, 0, IMAGE_WIDTH, [self frame].size.height)];
    } else if (stringSize.width <= [model maxStaticWidth]) {
        scrolling = NO;
        [self setFrame:NSMakeRect(0,
                                  0,
                                  stringSize.width +([model showIcons] ? IMAGE_WIDTH : 0) + EXTRA_SPACE_STATIC * 2,
                                  [self frame].size.height)];
    } else {
        timer = [NSTimer scheduledTimerWithTimeInterval:INTERVAL
                                                 target:self
                                               selector:@selector(refresh)
                                               userInfo:nil
                                                repeats:YES];
        // More than just a state change.
        if (!scrolling || textChanged) {
            scrollCurrentOffset = -PX_BEFORE_SCROLLS;
        }
        stringPixelLength = stringSize.width;
        scrolling = YES;
        [self setFrame:NSMakeRect(0, 0, [model maxScrollingWidth] + ([model showIcons] ? IMAGE_WIDTH : 0), [self frame].size.height)];
    }
    [self setNeedsDisplay:YES];
}

- (void) refresh {
    [statusItem drawStatusBarBackgroundInRect:[self bounds] withHighlight:[model menuVisible]];
    if ([model menuVisible]) {
        [drawStringAttributes setValue:[NSColor selectedMenuItemTextColor] forKey:NSForegroundColorAttributeName];
    } else {
        [drawStringAttributes setValue:[NSColor controlTextColor] forKey:NSForegroundColorAttributeName];
    }

    PlayerState state = [model state];
    if (state != STOP && ([model showPauseText] || state == PLAY)) {
        NSString *t = [model text];
        if (scrolling) {
            scrollCurrentOffset += SCROLL_SPEED;
            if (scrollCurrentOffset >= stringPixelLength) {
                scrollCurrentOffset = -PX_BETWEEN_SCROLLS;
            }
            
            NSPoint centerPoint;
            centerPoint.y = VERTICAL_OFFSET;
            
            // Draw text on left side.
            centerPoint.x = -scrollCurrentOffset + ([model showIcons] ? IMAGE_WIDTH : 0);
            [t drawAtPoint:centerPoint withAttributes:drawStringAttributes];
            
            // Draw text on right side, if applicable.
            float endOfStringOffset = stringPixelLength - scrollCurrentOffset + PX_BETWEEN_SCROLLS;
            if (endOfStringOffset < [model maxScrollingWidth]) {
                centerPoint.x = endOfStringOffset + ([model showIcons] ? IMAGE_WIDTH : 0);
                [t drawAtPoint:centerPoint withAttributes:drawStringAttributes];
            }
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
    if ([model menuVisible]) {
        [filename appendString:@"Hi"];
    }
    if (state == STOP || [model showIcons]) {
        [self drawImage:[imageDict objectForKey:filename]];
    } else if (state == PAUSE && ![model showPauseText]) {
        if ([model menuVisible]) {
            [self drawImage:[imageDict objectForKey:@"noteHi"]];
        } else {
            [self drawImage:[imageDict objectForKey:@"note"]];
        }
    }
}

- (void) drawImage:(NSImage*)img {
    // Clear the space of text before we draw the image over it.
    [statusItem drawStatusBarBackgroundInRect:NSMakeRect(0, 0, IMAGE_WIDTH, IMAGE_HEIGHT) withHighlight:[model menuVisible]];
    [img drawAtPoint:NSZeroPoint fromRect:NSZeroRect operation:NSCompositeSourceOver fraction:1];
}

// We have to manage our own events if we're sitting inside a status item.
- (void) mouseDown:(NSEvent*)event {
    NSTimer *updateWhileTracking;
    if (scrolling) {
        updateWhileTracking = [NSTimer timerWithTimeInterval:INTERVAL
                                                      target:self
                                                    selector:@selector(refresh)
                                                    userInfo:nil
                                                     repeats:YES];
        [[NSRunLoop currentRunLoop] addTimer:updateWhileTracking forMode:NSEventTrackingRunLoopMode];
    }
    [statusItem popUpStatusItemMenu:[statusItem menu]];
    [updateWhileTracking invalidate];
    [self setNeedsDisplay:YES];
}

- (void) rightMouseDown:(NSEvent*)event {
    [self mouseDown:event];
}

- (void) observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    if ([keyPath isEqualToString:@"menuVisible"]) {
        [self setNeedsDisplay:YES];
        return;
    }
    BOOL textChanged = NO;
    if ([keyPath isEqualToString:@"text"]) {
        textChanged = ![[change objectForKey:@"new"] isEqualToString:[change objectForKey:@"old"]];
    }
    [self resize:textChanged];
    if (textChanged) {
        [[statusItem menu] cancelTracking];
    }
}


@end
