//
//  AwardsTableViewCell.h
//  MHacks
//
//  Created by Chris McGrath on 8/30/14.
//  Copyright (c) 2014 hshacks.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AwardsTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *prizeMoneyLabel;
@property (weak, nonatomic) IBOutlet UILabel *companyLabel;
@property (weak, nonatomic) IBOutlet UILabel *detailLabel;

@end
