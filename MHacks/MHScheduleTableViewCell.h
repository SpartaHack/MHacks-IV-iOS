//
//  MHScheduleTableViewCell.h
//  MHacks
//
//  Created by Ben Oztalay on 8/31/14.
//  Copyright (c) 2014 hshacks.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>

@interface MHScheduleTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *detailLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeAndSponsorLabel;

+ (NSDateFormatter*)timeFormatter;

- (void)setWithEvent:(PFObject*)event;

@end
