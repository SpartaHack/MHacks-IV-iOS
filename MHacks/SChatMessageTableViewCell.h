//
//  SChatMessageTableViewCell.h
//  Sacks
//
//  Created by Ben Oztalay on 8/27/14.
//  Copyright (c) 2014 hshacks.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SChatMessageTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *profilePic;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *messageLabel;

+ (NSString*)cellIdentifier;

- (void)setWithChatMessage:(NSDictionary*)chatMessage atIndex:(NSInteger)index;

@end
