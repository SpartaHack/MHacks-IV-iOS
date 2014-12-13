//
//  SChatRoomTableViewCell.m
//  Sacks
//
//  Created by Ben Oztalay on 9/1/14.
//  Copyright (c) 2014 hshacks.com. All rights reserved.
//

#import "SChatRoomTableViewCell.h"

@implementation SChatRoomTableViewCell

- (void)setWithChatRoom:(NSDictionary*)chatRoom
{
    self.titleLabel.text = chatRoom[@"title"];
    self.detailLabel.text = chatRoom[@"details"];
}

@end
