//
//  MHChatMessageTableViewCell.m
//  MHacks
//
//  Created by Ben Oztalay on 8/27/14.
//  Copyright (c) 2014 hshacks.com. All rights reserved.
//

#import "MHChatMessageTableViewCell.h"
#import "UIColor+MHacksColors.h"
#import "SDWebImage/UIImageView+WebCache.h"

@implementation MHChatMessageTableViewCell

+ (NSString*)cellIdentifier
{
    static NSString* CellIdentifier = @"ChatCell";
    return CellIdentifier;
}

- (void)awakeFromNib
{
    self.profilePic.layer.cornerRadius = self.profilePic.frame.size.width / 2;
}

- (void)setWithChatMessage:(NSDictionary*)chatMessage atIndex:(NSInteger)index
{
    [self.profilePic setImageWithURL:[NSURL URLWithString:chatMessage[@"image"]] placeholderImage:[UIImage imageNamed:@"placeholderIcon.png"]];
    self.nameLabel.text = chatMessage[@"user"];
    self.messageLabel.text = chatMessage[@"message"];
    
    if(index % 2 == 0) {
        self.backgroundColor = [UIColor chatMessageCellEvenBackgroundColor];
    } else {
        self.backgroundColor = [UIColor chatMessageCellOddBackgroundColor];
    }
}

@end
