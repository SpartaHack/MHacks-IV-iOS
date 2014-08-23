//
//  UpdatesTableViewCell.m
//  MHacks
//
//  Created by Chris McGrath on 8/22/14.
//  Copyright (c) 2014 hshacks.com. All rights reserved.
//

#import "UpdatesTableViewCell.h"

@implementation UpdatesTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
