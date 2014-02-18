//
//  CountdownViewController.m
//  HSHacks
//
//  Created by Spencer Yen on 2/17/14.
//  Copyright (c) 2014 hshacks.com. All rights reserved.
//

#import "CountdownViewController.h"

@interface CountdownViewController ()

@end

@implementation CountdownViewController
@synthesize countdown, interval;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat: @"MM/dd/yyyy HH:mm:ss"];
    
    today = [NSDate date];
    HShacksDate = [formatter dateFromString:@"03/08/2014 13:00:00"];
    NSCalendar *gregorianCalendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];

    daysComponent = [gregorianCalendar components:NSDayCalendarUnit
                                         fromDate: today
                                           toDate:HShacksDate
                                          options:0];
    hoursComponent = [gregorianCalendar components:NSHourCalendarUnit
                                                            fromDate: today
                                                              toDate:HShacksDate
                                                             options:0];


    
    
    NSLog(@"lol %@ %@", today, HShacksDate);
    
    [NSTimer scheduledTimerWithTimeInterval:1.0
                                     target:self
                                   selector:@selector(countdownDisplay:)
                                   userInfo:nil
                                    repeats:YES];
    
    
}

-(void)checkDate{
    if([today compare: HShacksDate] == NSOrderedAscending){
        NSLog(@"wow hshacks hasnt begun yet");
        interval.text = @"Hacking has not begun. HShacks will begin in:";
        isStarting = TRUE;
        hasEnded = FALSE;
        hasEnded = FALSE;
    }
    else if ([today compare: HShacksDate] == NSOrderedSame){
        interval.text = @"Hacking has begun. HShacks will be over in:";
        isStarting = FALSE;
        hasEnded = TRUE;
        hasEnded = FALSE;
    }
    else if ([today compare: HShacksDate] == NSOrderedDescending){
        interval.text = @"Hacking has ended!";
        isStarting = FALSE;
        hasEnded = FALSE;
        hasEnded = TRUE;
    }
}

-(void)countdownDisplay:(id)sender{
    today = [NSDate date];
    [self checkDate];
    
    if(isStarting){
                             NSDateComponents *minsComponent = [gregorianCalendar components:NSMinuteCalendarUnit
                                                               fromDate: today
                                                                 toDate:HShacksDate
                                                                options:0];
        NSDateComponents *secsComponent = [gregorianCalendar components:NSSecondCalendarUnit
                                                               fromDate: today
                                                                 toDate:HShacksDate
                                                                options:0];
        
        NSInteger days = [daysComponent day];
        NSInteger hours = [hoursComponent hour];
        NSInteger mins = [minsComponent minute];
        NSInteger secs = [secsComponent second];
        
        NSLog(@"%li %li %li %li until HSHacks starts!", (long)days, (long)hours, (long)mins, (long)secs);
        
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end