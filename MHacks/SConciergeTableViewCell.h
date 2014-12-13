//
//  SConciergeTableViewCell.h
//  Sacks
//
//  Created by Ben Oztalay on 8/31/14.
//  Copyright (c) 2014 hshacks.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>

@interface SConciergeTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *positionLabel;
@property (weak, nonatomic) IBOutlet UILabel *specialtyLabel;
@property (weak, nonatomic) IBOutlet UIImageView *leftContactIcon;
@property (weak, nonatomic) IBOutlet UIImageView *rightContactIcon;

- (void)setWithUser:(PFObject*)user;

@end
