//
//  UpdatesTableViewCell.h
//  Sacks
//
//  Created by Chris McGrath on 8/22/14.
//  Copyright (c) 2014 hshacks.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>

@interface SUpdatesTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *detailLabel;
@property (weak, nonatomic) IBOutlet UILabel *pinnedLabel;

- (void)setWithAnnouncement:(PFObject*)announcement;

@end
