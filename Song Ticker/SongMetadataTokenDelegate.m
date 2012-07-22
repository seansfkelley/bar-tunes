//
//  SongMetadataTokenDelegate.m
//  Song Ticker
//
//  Created by Sean Kelley on 7/21/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "SongMetadataTokenDelegate.h"

@implementation SongMetadataTokenDelegate

NSArray *validElements;

- (id) init {
    validElements = [NSArray arrayWithObjects:@"Artist", @"Album", @"Title", nil];
    return self;
}

- (NSArray*) tokenField:(NSTokenField *)tokenField completionsForSubstring:(NSString *)substring indexOfToken:(NSInteger)tokenIndex indexOfSelectedItem:(NSInteger *)selectedIndex {
    return [validElements filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"self beginswith[cd] %@", substring]];
}

- (NSTokenStyle) tokenField:(NSTokenField *)tokenField styleForRepresentedObject:(NSString*)representedObject {
    if ([validElements containsObject:representedObject]) {
        return NSRoundedTokenStyle;
    } else {
        return NSPlainTextTokenStyle;
    }
}

@end
