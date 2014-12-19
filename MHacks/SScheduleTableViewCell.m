//
//  SScheduleTableViewCell.m
//  Sacks
//
//  Created by Ben Oztalay on 8/31/14.
//  Copyright (c) 2014 hshacks.com. All rights reserved.
//

#import "SScheduleTableViewCell.h"

@implementation SScheduleTableViewCell

+ (NSDateFormatter*)timeFormatter
{
    static NSDateFormatter* dateFormatter = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setTimeZone:[NSTimeZone timeZoneWithName:@"UTC"]];
        [dateFormatter setDateFormat:@"h:mm a"];
    });
    
    return dateFormatter;
}

- (void)setWithEvent:(PFObject*)event
{
    self.titleLabel.text = event[@"Title"];
    self.detailLabel.text = event[@"Details"];
    
    NSString* timeString = [[SScheduleTableViewCell timeFormatter] stringFromDate:event[@"time"]];
    self.timeAndSponsorLabel.text = [NSString stringWithFormat:@"%@ | %@", event[@"host"][@"title"], timeString];
}

@end
