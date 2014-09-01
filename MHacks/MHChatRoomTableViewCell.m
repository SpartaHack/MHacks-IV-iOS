//
//  MHChatRoomTableViewCell.m
//  MHacks
//
//  Created by Ben Oztalay on 9/1/14.
//  Copyright (c) 2014 hshacks.com. All rights reserved.
//

#import "MHChatRoomTableViewCell.h"

@implementation MHChatRoomTableViewCell

- (void)setWithChatRoom:(NSDictionary*)chatRoom
{
    self.titleLabel.text = chatRoom[@"title"];
    self.detailLabel.text = chatRoom[@"details"];
}

@end
