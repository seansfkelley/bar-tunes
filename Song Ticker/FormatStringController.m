//
//  FormatStringController.m
//  Song Ticker
//
//  Created by Sean Kelley on 7/28/12.
//
//

#import "FormatStringController.h"

@implementation FormatStringController

- (FormatStringController*) initWithModel:(FormatStringModel*)m withView:(FormatStringView*)v{
    self = [super init];
    model = m;
    view = v;
    return self;
}

- (IBAction) popupWindow:(id)sender {
    [view bringFormatWindowToFrontWithDelegate:self];
}

- (void) closeWindowAndSave:(id)sender save:(BOOL)s {
    if (s) {
        [model setFormatString:[view formatFieldContents]];
    }
    [view closeWindow:sender];
}

- (IBAction) cancel:(id)sender {
    [self closeWindowAndSave:sender save:NO];
}

- (IBAction) save:(id)sender {
    [self closeWindowAndSave:sender save:YES];
}

- (void) windowDidResignKey:(NSNotification *)note {
    [self cancel:self];
}

- (void) cancelOperation:(id)sender {
    [self cancel:self];
}

@end
