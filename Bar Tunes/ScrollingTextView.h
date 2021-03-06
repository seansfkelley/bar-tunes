#import <Cocoa/Cocoa.h>
#import "DisplayModel.h"
#import "FormatStringController.h"

@interface ScrollingTextView : NSView {
    NSMutableDictionary *drawStringAttributes;
    
    NSTimer *timer;
    BOOL scrolling;
    float stringPixelLength;
    float scrollCurrentOffset;
    
    const NSDictionary *imageDict;
    NSImage *currentImage;
}

@property DisplayModel *model;

// Should be called after any change in the model.
- (void) resize:(BOOL)textChanged;

@property NSStatusItem *statusItem;

// Called when the display state or text changes.
- (void) observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context;

@end
