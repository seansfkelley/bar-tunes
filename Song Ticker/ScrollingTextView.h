//
//  ScrollingTextView.h
//  Song Ticker
//
//  Created by Sean Kelley on 7/20/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "DisplayModel.h"
#import "FormatStringController.h"

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

typedef enum changeType {
    PLAYER_STATE,
    DISPLAY_TEXT
} ChangeType;

@property DisplayModel *model;

// Should be called after any change in the model.
- (void) resize:(ChangeType)c;

@property NSStatusItem *statusItem;
@property FormatStringController *formatController;

// Called when the display state or text changes.
- (void) observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context;

@end
