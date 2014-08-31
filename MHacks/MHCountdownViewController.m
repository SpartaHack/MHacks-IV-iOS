//
//  CountdownViewController.m
//  HSHacks
//
//  Created by Spencer Yen (noob) on 2/17/14.
//  Copyright (c) 2014 hshacks.com. All rights reserved.
//  Alex Yeh too pro!!!!!!!!!
//

#import "MHCountdownViewController.h"
#import "UIImage+animatedGIF.h"

@implementation MHCountdownViewController
@synthesize countdown, interval, timerImage;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    timerImage.image = [UIImage animatedImageWithAnimatedGIFURL:[NSURL URLWithString:@"http://i.imgur.com/bA6o3mj.gif"]];
    interval.text = [NSString stringWithFormat:@""];
   
    [self countdownDisplay:nil];
    formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat: @"MM/dd/yyyy HH:mm:ss"];
    
    today = [NSDate date];
    MhacksBegin = [formatter dateFromString:@"09/05/2014 17:00:00"];
    MhacksEnd = [formatter dateFromString:@"09/07/2014 16:00:00"];

   gregorianCalendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];

    
    [NSTimer scheduledTimerWithTimeInterval:1.0
                                        target:self
                                        selector:@selector(countdownDisplay:)
                                        userInfo:nil
                                        repeats:YES];
    
    
}

-(void)checkDate{
    if([today compare: MhacksBegin] == NSOrderedAscending && [today compare: MhacksEnd] == NSOrderedAscending){
        interval.text = @"Hacking begins in:";
        isStarting = TRUE;
        hasStarted = FALSE;
        hasEnded = FALSE;
    }
    else if ([today compare: MhacksBegin] == NSOrderedSame || ([today compare: MhacksEnd] == NSOrderedAscending && [today compare: MhacksBegin] == NSOrderedAscending)){
        interval.text = @"Hacking ends in:";
        isStarting = FALSE;
        hasStarted = TRUE;
        hasEnded = FALSE;
    }
    else if ([today compare: MhacksBegin] == NSOrderedDescending && [today compare: MhacksEnd] == NSOrderedDescending){
        interval.text = @"Hacking has ended!";
        isStarting = FALSE;
        hasStarted = FALSE;
        hasEnded = TRUE;
    }
}

-(void)countdownDisplay:(id)sender{
    today = [NSDate date];
    [self checkDate];
    NSUInteger unitFlags = NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit|NSHourCalendarUnit|NSMinuteCalendarUnit|NSSecondCalendarUnit;
    if(isStarting){
     
        NSDateComponents *dateComponents = [gregorianCalendar components:unitFlags fromDate:today toDate:MhacksBegin options:0];
        
        NSNumber *days = [NSNumber numberWithInteger:[dateComponents day]];
        NSNumber *hours = [NSNumber numberWithInteger:[dateComponents hour]];
        NSNumber *mins = [NSNumber numberWithInteger:[dateComponents minute]];
        NSNumber *secs = [NSNumber numberWithInteger:[dateComponents second]];
        
        NSString *s = [days stringValue];
        s = [s stringByAppendingString:@" days  "];
        s = [s stringByAppendingString:[hours stringValue]];
        s = [s stringByAppendingString:@" hours  "];
        s = [s stringByAppendingString:[mins stringValue]];
        s = [s stringByAppendingString:@" minutes  "];
        s = [s stringByAppendingString:[secs stringValue]];
        s = [s stringByAppendingString:@" seconds  "];
        
        countdown.text = s;
      
        
    }
    else if (hasStarted){
        NSDateComponents *dateComponents = [gregorianCalendar components:unitFlags fromDate:MhacksBegin toDate:MhacksEnd options:0];
        
        NSNumber *days = [NSNumber numberWithInteger:[dateComponents day]];
        NSNumber *hours = [NSNumber numberWithInteger:[dateComponents hour]];
        NSNumber *mins = [NSNumber numberWithInteger:[dateComponents minute]];
        NSNumber *secs = [NSNumber numberWithInteger:[dateComponents second]];
        
        NSString *s = [days stringValue];
        s = [s stringByAppendingString:@" days "];
        s = [s stringByAppendingString:[hours stringValue]];
        s = [s stringByAppendingString:@" hours "];
        s = [s stringByAppendingString:[mins stringValue]];
        s = [s stringByAppendingString:@" minutes "];
        s = [s stringByAppendingString:[secs stringValue]];
        s = [s stringByAppendingString:@" seconds "];
        
        countdown.text = s;
       

    }
    else if (hasEnded){
        countdown.text = @"We hope you enjoyed MHacks!";
    }
}

@end