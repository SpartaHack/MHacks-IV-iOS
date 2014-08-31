//
//  AwardsTableViewCell.m
//  MHacks
//
//  Created by Chris McGrath on 8/30/14.
//  Copyright (c) 2014 hshacks.com. All rights reserved.
//

#import "AwardsTableViewCell.h"

@implementation AwardsTableViewCell

- (void)setWithAward:(PFObject*)award
{
    self.prizeMoneyLabel.text = award[@"prize"];
    self.companyLabel.text = award[@"sponsor"][@"title"];
    self.detailLabel.text = award[@"details"];
}

@end
