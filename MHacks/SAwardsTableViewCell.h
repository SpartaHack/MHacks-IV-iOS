//
//  AwardsTableViewCell.h
//  Sacks
//
//  Created by Chris McGrath on 8/30/14.
//  Copyright (c) 2014 hshacks.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>

@interface SAwardsTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *prizeMoneyLabel;
@property (weak, nonatomic) IBOutlet UILabel *companyLabel;
@property (weak, nonatomic) IBOutlet UILabel *detailLabel;

- (void)setWithAward:(PFObject*)award;

@end
