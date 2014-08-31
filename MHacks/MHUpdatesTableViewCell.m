//
//  UpdatesTableViewCell.m
//  MHacks
//
//  Created by Chris McGrath on 8/22/14.
//  Copyright (c) 2014 hshacks.com. All rights reserved.
//

#import "MHUpdatesTableViewCell.h"

@implementation MHUpdatesTableViewCell

- (void)setWithAnnouncement:(PFObject*)announcement
{
    self.titleLabel.text = announcement[@"title"];
    self.detailLabel.text = announcement[@"details"];
    self.pinnedLabel.hidden = ![announcement[@"pinned"] boolValue];
}

@end
