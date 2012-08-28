#import <Foundation/Foundation.h>
#import "DisplayModel.h"
#import "ScrollingTextView.h"
#import "FormatStringPackage.h"
#import "UnifiedPlayerModel.h"

@interface DisplayController : NSObject <NSMenuDelegate> {
    IBOutlet NSMenuItem *showIconsMenuItem;
    IBOutlet NSMenuItem *showPauseTextMenuItem;
    IBOutlet NSMenuItem *useWideDisplayMenuItem;
}

@property DisplayModel *model;
@property ScrollingTextView *view;
@property UnifiedPlayerModel *playerModel;
@property FormatStringModel *formatModel;

- (void) setShowIcons:(BOOL)showIcons;
- (void) setShowPauseText:(BOOL)showPauseText;
- (void) setUseWideDisplay:(BOOL)useWideDisplay;

- (IBAction) toggleShowIcons:(id)sender;
- (IBAction) toggleShowPauseText:(id)sender;
- (IBAction) toggleUseWideDisplay:(id)sender;

// Called when the format string changes or the player info changes.
- (void) observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context;

@end
