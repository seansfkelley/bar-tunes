#import "DisplayModel.h"

const static int MAX_STATIC_WIDTH_WIDE = 300;
const static int MAX_SCROLLING_WIDTH_WIDE = 250;
const static int MAX_STATIC_WIDTH_NARROW = 200;
const static int MAX_SCROLLING_WIDTH_NARROW = 175;

@implementation DisplayModel

@synthesize text;
@synthesize state;
@synthesize showIcons;
@synthesize showPauseText;
@synthesize useWideDisplay;
@synthesize menuVisible;

- (DisplayModel*) init {
    self = [super init];
    text = @"";
    return self;
}

- (int) maxStaticWidth {
    return useWideDisplay ? MAX_STATIC_WIDTH_WIDE : MAX_STATIC_WIDTH_NARROW;
}

- (int) maxScrollingWidth {
    return useWideDisplay ? MAX_SCROLLING_WIDTH_WIDE : MAX_SCROLLING_WIDTH_NARROW;
}

@end
