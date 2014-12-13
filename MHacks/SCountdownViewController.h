//
//  CountdownViewController.h
//  HSHacks
//
//  Created by Spencer Yen on 2/17/14.
//  Copyright (c) 2014 hshacks.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SCountdownViewController : UIViewController {
    NSDate *today;
    NSDate *SacksBegin;
    NSDate *SacksEnd;
    NSDateFormatter *formatter;
    NSCalendar *gregorianCalendar;
    
    BOOL isStarting;
    BOOL hasStarted;
    BOOL hasEnded;
    
    NSDateComponents *daysComponent;
    NSDateComponents *hoursComponent;
    NSDateComponents *minsComponent;
    NSDateComponents *secsComponent;
}

@property (nonatomic, retain) IBOutlet UILabel *interval;
@property (nonatomic, retain) IBOutlet UILabel *countdown;
@property (weak, nonatomic) IBOutlet UIImageView *clockOutline;
@property (strong, nonatomic) UIImageView* clockHour;
@property (strong, nonatomic) UIImageView* clockMinute;

@end
