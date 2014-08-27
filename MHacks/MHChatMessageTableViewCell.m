//
//  MHChatMessageTableViewCell.m
//  MHacks
//
//  Created by Ben Oztalay on 8/27/14.
//  Copyright (c) 2014 hshacks.com. All rights reserved.
//

#import "MHChatMessageTableViewCell.h"

@implementation MHChatMessageTableViewCell

- (void)awakeFromNib
{
    self.profilePic.layer.cornerRadius = self.profilePic.frame.size.width / 2;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
