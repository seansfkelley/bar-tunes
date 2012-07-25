//
//  NSStatusBar+Undocumented.h
//  Song Ticker
//
//  Created by Sean Kelley on 7/25/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

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