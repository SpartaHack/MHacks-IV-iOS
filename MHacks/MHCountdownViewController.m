//
//  CountdownViewController.m
//  HSHacks
//
//  Created by Spencer Yen (noob) on 2/17/14.
//  Copyright (c) 2014 hshacks.com. All rights reserved.
//  Alex Yeh too pro!!!!!!!!!
//

#import "MHCountdownViewController.h"

@implementation MHCountdownViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.clockOutline.image = [self.clockOutline.image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    
    self.clockHour = [[UIImageView alloc] initWithFrame:self.clockOutline.frame];
    self.clockHour.tintColor = self.clockOutline.tintColor;
    self.clockHour.image = [[UIImage imageNamed:@"hour"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    [self.view addSubview:self.clockHour];
    
    self.clockMinute = [[UIImageView alloc] initWithFrame:self.clockOutline.frame];
    self.clockMinute.tintColor = self.clockOutline.tintColor;
    self.clockMinute.image = [[UIImage imageNamed:@"minute"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    [self.view addSubview:self.clockMinute];
    
    formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat: @"MM/dd/yyyy HH:mm:ss"];
    
    MhacksBegin = [formatter dateFromString:@"09/05/2014 18:00:00"];
    MhacksEnd = [formatter dateFromString:@"09/07/2014 16:00:00"];
    
    gregorianCalendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    
    [self countdownDisplay:nil];
    [NSTimer scheduledTimerWithTimeInterval:1.0
                                     target:self
                                   selector:@selector(countdownDisplay:)
                                   userInfo:nil
                                    repeats:YES];
}

- (void)checkDate
{
    if([today compare: MhacksBegin] == NSOrderedAscending) {
        self.interval.text = @"Hacking begins in:";
        isStarting = TRUE;
        hasStarted = FALSE;
        hasEnded = FALSE;
    } else if ([today compare: MhacksBegin] == NSOrderedDescending && [today compare: MhacksEnd] == NSOrderedAscending) {
        self.interval.text = @"Hacking ends in:";
        isStarting = FALSE;
        hasStarted = TRUE;
        hasEnded = FALSE;
    } else if ([today compare: MhacksEnd] == NSOrderedDescending) {
        self.interval.text = @"Hacking has ended!";
        isStarting = FALSE;
        hasStarted = FALSE;
        hasEnded = TRUE;
    }
}

- (void)countdownDisplay:(id)sender
{
    today = [NSDate date];
    [self checkDate];
    NSUInteger unitFlags = NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit|NSHourCalendarUnit|NSMinuteCalendarUnit|NSSecondCalendarUnit;
    
    if (hasEnded) {
        self.countdown.text = @"We hope you enjoyed MHacks!";
    } else {
        NSDateComponents *dateComponents = nil;
        
        if (isStarting) {
            dateComponents = [gregorianCalendar components:unitFlags fromDate:today toDate:MhacksBegin options:0];
        } else if (hasStarted) {
            dateComponents = [gregorianCalendar components:unitFlags fromDate:today toDate:MhacksEnd options:0];
        }
        
        NSNumber *days = [NSNumber numberWithInteger:[dateComponents day]];
        NSNumber *hours = [NSNumber numberWithInteger:[dateComponents hour]];
        NSNumber *mins = [NSNumber numberWithInteger:[dateComponents minute]];
        NSNumber *secs = [NSNumber numberWithInteger:[dateComponents second]];
        
        NSString* countdownText = [NSString stringWithFormat:@"%@ days %@ hours %@ minutes %@ seconds", days, hours, mins, secs];
        self.countdown.text = countdownText;
    }
    
    NSDateComponents* todayComponents = [gregorianCalendar components:unitFlags fromDate:today];
    
    [UIView animateWithDuration:0.25f animations:^{
        CGFloat hoursValueToUse = (float)[todayComponents hour];
        if (hoursValueToUse > 12.0f) {
            hoursValueToUse -= 12.0f;
        }
        CGFloat hoursAngle = (hoursValueToUse / 12.0f) * (2.0f * M_PI);
        self.clockHour.transform = CGAffineTransformMakeRotation(hoursAngle);
        
        CGFloat minutesAngle = ((float)[todayComponents minute] / 60.0f) * (2.0f * M_PI);
        self.clockMinute.transform = CGAffineTransformMakeRotation(minutesAngle);
    } completion:nil];
}

@end