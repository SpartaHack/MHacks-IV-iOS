//
//  UpdatesTableViewCell.m
//  MHacks
//
//  Created by Chris McGrath on 8/22/14.
//  Copyright (c) 2014 hshacks.com. All rights reserved.
//

#import "UpdatesTableViewCell.h"

@implementation UpdatesTableViewCell

- (void)setWithAnnouncement:(PFObject*)announcement
{
    self.titleLabel.text = announcement[@"title"];
    self.detailLabel.text = announcement[@"details"];
    self.pinnedLabel.hidden = ![announcement[@"pinned"] boolValue];
}

@end
