//
//  FormatStringController.h
//  Song Ticker
//
//  Created by Sean Kelley on 7/28/12.
//
//

#import <Foundation/Foundation.h>
#import "FormatStringModel.h"
#import "FormatStringView.h"

@interface FormatStringController : NSObject <NSWindowDelegate> {
    FormatStringModel *model;
    FormatStringView *view;
}

- (FormatStringController*) initWithModel:(FormatStringModel*)m withView:(FormatStringView*)v;

- (IBAction) popupWindow:(id)sender;
- (IBAction) cancel:(id)sender;
- (IBAction) save:(id)sender;

// NSWindowDelegate
- (void) windowDidResignKey:(NSNotification *)note;
- (void) cancelOperation:(id)sender;

@end
