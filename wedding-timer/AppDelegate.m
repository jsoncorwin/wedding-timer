//
//  AppDelegate.m
//  wedding-timer
//
//  Created by Jason Corwin on 4/29/15.
//  Copyright (c) 2015 Jason M Corwin. All rights reserved.
//

#import "AppDelegate.h"

@interface AppDelegate ()

@property (weak) IBOutlet NSWindow *window;
@property (strong, nonatomic) NSStatusItem *statusItem;
@property (assign, nonatomic) BOOL heartOn;
@property (assign, nonatomic) long days;

@property (weak) NSTimer *repeatingTimer;
@property NSUInteger timerCount;

@end

@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
    self.statusItem = [[NSStatusBar systemStatusBar] statusItemWithLength:30.0];

    self.heartOn = YES;
    [self performSelector:@selector(calculateDays:)];

    
    _statusItem.image = [NSImage imageNamed:@"heart.png"];
    [_statusItem.image setTemplate:YES];
    
    [_statusItem setAction:@selector(itemClicked:)];
    [self startRepeatingTimer];
}

- (void)applicationWillTerminate:(NSNotification *)aNotification {
    // Insert code here to tear down your application
}

- (void)itemClicked:(id)sender {
    self.heartOn ^= YES;

    if (self.heartOn) {
        _statusItem.title = nil;
        _statusItem.image = [NSImage imageNamed:@"heart.png"];
    } else {
        _statusItem.image = nil;
        _statusItem.title = [NSString stringWithFormat:@"%ld", self.days];
    }
    
    
}

- (NSDictionary *)userInfo {
    return @{ @"StartDate" : [NSDate date] };
}

- (void)calculateDays:(id)sender {
    NSDate *now = [NSDate date];
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setTimeZone:[NSTimeZone systemTimeZone]];
    [dateFormat setLocale:[NSLocale currentLocale]];
    [dateFormat setDateFormat:@"yyyy-MM-dd"];
    [dateFormat setFormatterBehavior:NSDateFormatterBehaviorDefault];
    NSDate *wedding = [dateFormat dateFromString:@"2015-8-22"];
    
    NSTimeInterval secondsBetween = [wedding timeIntervalSinceDate:now];
    self.days = ceil(secondsBetween / 86400);
    
    if (!self.heartOn) {
        _statusItem.title = [NSString stringWithFormat:@"%ld", self.days];
    }

//    _statusItem.toolTip = [NSString stringWithFormat:@"%ld", self.days];
}


- (void)startRepeatingTimer {
    NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:5 target:self selector:@selector(calculateDays:) userInfo:[self userInfo] repeats:YES];
    self.repeatingTimer = timer;
}



@end
