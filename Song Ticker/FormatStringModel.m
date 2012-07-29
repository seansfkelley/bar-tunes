//
//  FormatWindowModel.m
//  Song Ticker
//
//  Created by Sean Kelley on 7/27/12.
//
//

#import "FormatStringModel.h"

@implementation FormatStringModel

@synthesize formatString;

- (FormatStringModel*) init {
    self = [super init];
    formatString = @"";
    return self;
}

- (BOOL) isFormatStringOK:(NSString*)f {
    return (![f isEqualToString:@""] && ([f rangeOfString:@"%album"].location != NSNotFound ||
                                         [f rangeOfString:@"%artist"].location != NSNotFound ||
                                         [f rangeOfString:@"%number"].location != NSNotFound ||
                                         [f rangeOfString:@"%song"].location != NSNotFound));
}

- (void) setFormatString:(NSString *)f {
    if (![self isFormatStringOK:f]) {
        return;
    }
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:f forKey:DEFAULTS_KEY_FORMAT_STRING];
    [defaults synchronize];
    formatString = f;
}

@end
