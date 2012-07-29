#import "AppDelegate.h"

@implementation AppDelegate

- (void) awakeFromNib {
    // Display component MVC
    displayModel = [[DisplayModel alloc] init];
    [displayView setModel:displayModel];
    [displayController setModel:displayModel];
    [displayController setView:displayView];
    
    // Format component MVC
    formatModel = [[FormatStringModel alloc] init];
    [formatView setModel:formatModel];
    [formatController setModel:formatModel];
    [formatController setView:formatView];
    
    // Format other
    [formatView setAnchor:displayView];
    
    // Player component MVC
    playerModel = [[UnifiedPlayerModel alloc] init];
    [playerControlView setModel:playerModel];
    [playerController setModel:playerModel];
    
    // Set up other models
    [displayController setFormatModel:formatModel];
    [displayController setPlayerModel:playerModel];
    [playerControlView setDelegate:displayController];
    
    // Maintain consistent state listeners
    [formatModel addObserver:displayController forKeyPath:@"formatString" options:0 context:nil];
    [playerModel addObserver:displayController forKeyPath:@"player" options:0 context:nil];
    
    // Update display listeners
    [displayModel addObserver:displayView forKeyPath:@"state" options:0 context:nil];
    [displayModel addObserver:displayView forKeyPath:@"text" options:NSKeyValueObservingOptionNew |
                                                                     NSKeyValueObservingOptionOld context:nil];
    [displayModel addObserver:displayView forKeyPath:@"showIcons" options:0 context:nil];
    [displayModel addObserver:displayView forKeyPath:@"showPauseText" options:0 context:nil];
    [displayModel addObserver:displayView forKeyPath:@"menuVisible" options:0 context:nil];
    
    // Keep-UI-elements-from-interfering-with-each-other listeners
    [displayModel addObserver:formatController forKeyPath:@"menuVisible" options:NSKeyValueObservingOptionNew context:nil];
    
    // Initialize display with preferences, then fire event to make sure everything is updated.
    [self initializePreferences];
    [playerModel willChangeValueForKey:@"player"];
    [playerModel didChangeValueForKey:@"player"];
    
    // Put the application into the menu bar; set some view variables as necessary.
    NSStatusBar *systemStatusBar = [NSStatusBar systemStatusBar];
    NSStatusItem *statusItem = nil;
    
    // Undocumented behavior; may not always work. Fallback to standard behavior.
    if ([systemStatusBar respondsToSelector: @selector (_statusItemWithLength:withPriority:)]) {
        statusItem = [systemStatusBar _statusItemWithLength:0 withPriority:0];
        [statusItem setLength:NSVariableStatusItemLength];
    } else {
        statusItem = [systemStatusBar statusItemWithLength:NSVariableStatusItemLength];
    }
    
    [statusItem setHighlightMode:YES];
    [statusItem setView:displayView];
    [statusItem setMenu:playerControlView];
    
    [displayView setStatusItem:statusItem];
}

- (void) initializePreferences {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    [displayController setShowIcons:[defaults boolForKey:DEFAULTS_KEY_SHOW_ICONS]];
    [displayController setShowPauseText:[defaults boolForKey:DEFAULTS_KEY_SHOW_PAUSE_TEXT]];
    
    [playerControlView setWatch:(Player) [defaults integerForKey:DEFAULTS_KEY_PLAYER]];
    
    [formatModel setFormatString:[defaults objectForKey:DEFAULTS_KEY_FORMAT_STRING]];
}

- (IBAction) quitApplication:(id)sender {
    [[NSApplication sharedApplication] terminate:nil];
}

@end
