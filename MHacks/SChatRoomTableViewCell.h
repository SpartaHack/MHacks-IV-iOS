//
//  SChatRoomTableViewCell.h
//  Sacks
//
//  Created by Ben Oztalay on 9/1/14.
//  Copyright (c) 2014 hshacks.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SChatRoomTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *detailLabel;

- (void)setWithChatRoom:(NSDictionary*)chatRoom;

@end
