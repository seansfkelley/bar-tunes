#import <Cocoa/Cocoa.h>

int main(int argc, char *argv[])
{
    // Load up the default preferences before anything else starts.
    NSString *defaultPrefsFile = [[NSBundle mainBundle] pathForResource:@"DefaultPreferences" ofType:@"plist"];
    NSDictionary *defaultPreferences = [NSDictionary dictionaryWithContentsOfFile:defaultPrefsFile];
    [[NSUserDefaults standardUserDefaults] registerDefaults:defaultPreferences];
    
    return NSApplicationMain(argc, (const char **)argv);
}
