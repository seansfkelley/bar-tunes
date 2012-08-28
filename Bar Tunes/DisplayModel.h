#import <Foundation/Foundation.h>

@interface DisplayModel : NSObject

@property (readonly) int maxStaticWidth;
@property (readonly) int maxScrollingWidth;

@property NSString *text;
@property PlayerState state;
@property BOOL showIcons;
@property BOOL showPauseText;
@property BOOL useWideDisplay;
// Transient
@property BOOL menuVisible;

@end
