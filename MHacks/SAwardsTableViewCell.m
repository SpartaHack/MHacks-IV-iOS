//
//  AwardsTableViewCell.m
//  Sacks
//
//  Created by Chris McGrath on 8/30/14.
//  Copyright (c) 2014 hshacks.com. All rights reserved.
//

#import "SAwardsTableViewCell.h"

@implementation SAwardsTableViewCell

- (void)setWithAward:(PFObject*)award
{
    self.prizeMoneyLabel.text = award[@"Value"];
    self.companyLabel.text = award[@"Title"];
    self.detailLabel.text = award[@"details"];
}

@end
