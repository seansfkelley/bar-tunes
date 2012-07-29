#import "FormatStringView.h"

@implementation FormatStringView

@synthesize model;
@synthesize anchor;

- (void) awakeFromNib {
    // Set text to white; we also have to redo the size and alignment since we're clobbering
    // what we set in the .xib.
    NSMutableParagraphStyle *centerStyle = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
    [centerStyle setAlignment:NSCenterTextAlignment];
    NSDictionary *buttonTitleAttrs = [[NSMutableDictionary alloc] init];
	[buttonTitleAttrs setValue:[NSFont systemFontOfSize:11.0] forKey:NSFontAttributeName];
	[buttonTitleAttrs setValue:[NSColor whiteColor] forKey:NSForegroundColorAttributeName];
	[buttonTitleAttrs setValue:centerStyle forKey:NSParagraphStyleAttributeName];
    
    [albumButton  setAttributedTitle:[[NSAttributedString alloc] initWithString:@"%album" attributes:buttonTitleAttrs]];
    [artistButton setAttributedTitle:[[NSAttributedString alloc] initWithString:@"%artist" attributes:buttonTitleAttrs]];
    [numberButton setAttributedTitle:[[NSAttributedString alloc] initWithString:@"%number" attributes:buttonTitleAttrs]];
    [songButton   setAttributedTitle:[[NSAttributedString alloc] initWithString:@"%song" attributes:buttonTitleAttrs]];
}

- (void) bringFormatWindowToFrontWithDelegate:(id<NSWindowDelegate>)delegate{
    NSRect anchorFrame = [[anchor window] frame];
    formatWindow = [[MAAttachedWindow alloc] initWithView:self
                                            attachedToPoint:NSMakePoint(anchorFrame.origin.x + anchorFrame.size.width / 2, anchorFrame.origin.y)
                                                     onSide:NSMinYEdge
                                                 atDistance:5.0];
    
    [formatWindow setDelegate:delegate];
    [formatTextField setObjectValue:[model formatString]];
    [NSApp activateIgnoringOtherApps:YES];
    [formatWindow makeKeyAndOrderFront:self];
}

- (void) closeWindow:(id)sender {
    [formatWindow orderOut:self];
}

- (NSString*) formatFieldContents {
    return  [[formatTextField objectValue] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
}

- (NSTextView*) getTextView {
    NSResponder * responder = [[self window] firstResponder];
    if ((responder != nil) && [responder isKindOfClass:[NSTextView class]]) {
        return (NSTextView*) responder;
    }
    return nil;
}

- (void) insertString:(NSString*)s {
    NSTextView *textView = [self getTextView];
    if (textView != nil) {
        [textView insertText:s];
    } else {
        [formatTextField setStringValue:[[NSString alloc] initWithFormat:@"%@%@", [formatTextField stringValue], s]];
    }
}

- (IBAction) insertAlbumTag:(id)sender {
    [self insertString:@"%album"];
}

- (IBAction) insertArtistTag:(id)sender {
    [self insertString:@"%artist"];
}

- (IBAction) insertNumberTag:(id)sender {
    [self insertString:@"%number"];
}

- (IBAction) insertSongTag:(id)sender {
    [self insertString:@"%song"];
}

// No Edit menu; we have to support this type of stuff manually.
- (BOOL) performKeyEquivalent:(NSEvent *)e {
    NSTextView *textView = [self getTextView];
    if (([e type] == NSKeyDown) && ([e modifierFlags] & NSCommandKeyMask)) {
        bool handled = NO;
        if ([e keyCode] == 0) { // Cmd-A
            [textView selectAll:self];
            handled = YES;
        } else if ([e keyCode] == 6) { // Cmd-Z
            if ([[textView undoManager] canUndo]) {
                [[textView undoManager] undo];
                handled = YES;
            }
        }
        return handled;
    }
    return NO;
}

@end
