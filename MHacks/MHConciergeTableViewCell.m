//
//  MHConciergeTableViewCell.m
//  MHacks
//
//  Created by Ben Oztalay on 8/31/14.
//  Copyright (c) 2014 hshacks.com. All rights reserved.
//

#import "MHConciergeTableViewCell.h"

@implementation MHConciergeTableViewCell

- (void)setWithUser:(PFObject*)user
{
    self.nameLabel.text = user[@"name"];
    self.positionLabel.hidden = YES;
    self.specialtyLabel.text = user[@"specialty"];
}

@end
