#import "SinglePlayerModel.h"

@implementation SinglePlayerModel

@synthesize album;
@synthesize artist;
@synthesize name;
@synthesize trackNumber;
@synthesize state;

- (SinglePlayerModel*) init {
    self = [super init];
    album = @"";
    artist = @"";
    name = @"";
    trackNumber = @"";
    state = STOP;
    return self;
}

- (void) copyInfoFrom:(NSDictionary*)info {
    [self setAlbum: [info objectForKey:@"Album"]];
    [self setArtist:[info objectForKey:@"Artist"]];
    [self setName:  [info objectForKey:@"Name"]];
    [self setTrackNumber:[info objectForKey:@"Track Number"]];
    NSString *s = [info objectForKey:@"Player State"];
    if ([s isEqualToString:@"Playing"]) {
        [self setState:PLAY];
    } else if ([s isEqualToString:@"Paused"]) {
        [self setState:PAUSE];
    } else {
        [self setState:STOP];
    }
}

@end
