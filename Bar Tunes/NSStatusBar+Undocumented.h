// Add undocumented behavior to NSStatusBar, courtesy of StackOverflow.
// Used primarily for forcing the status item all the way to the left.
#import <Foundation/Foundation.h>

@interface NSStatusBar (NSStatusBar_Private)

- (id)_init;
- (void)_insertStatusItem:(id)fp8 withPriority:(int)fp12;
- (id)_lockName;
- (id)_name;
- (void)_refreshWindows;
- (void)_removeStatusItem:(id)fp8;
- (void)_setLengthOfStatusItem:(id)fp8 to:(float)fp12;
- (void)_setUpdatesDisabled:(BOOL)fp8;
- (id)_statusItemWithLength:(float)fp8 withPriority:(int)fp12;
- (BOOL)_updatesDisabled;

@end