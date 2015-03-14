//
//  UpdatesTableViewCell.m
//  Sacks
//
//  Created by Chris McGrath on 8/22/14.
//  Copyright (c) 2014 hshacks.com. All rights reserved.
//

#import "SUpdatesTableViewCell.h"

@implementation SUpdatesTableViewCell

- (void)setWithAnnouncement:(PFObject*)announcement
{
    self.titleLabel.text = announcement[@"title"];
    self.detailLabel.text = announcement[@"details"];
    self.pinnedLabel.hidden = ![announcement[@"pinned"] boolValue];
}



@end
