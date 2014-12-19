//
//  SConciergeTableViewCell.m
//  Sacks
//
//  Created by Ben Oztalay on 8/31/14.
//  Copyright (c) 2014 hshacks.com. All rights reserved.
//

#import "SConciergeTableViewCell.h"

@implementation SConciergeTableViewCell

- (void)setWithUser:(PFObject*)user
{
    self.nameLabel.text = user[@"Sponsor"][@"Name"];
//    NSLog(@"Name? %@",user[@"Sponsor"][@"Name"]);
    self.positionLabel.hidden = NO;
    self.specialtyLabel.text = user[@"Sponsor"][@"Specialty"];
    
    BOOL canEmail = (user[@"Sponsor"][@"email"] != nil);
    BOOL canTwitter = (user[@"Sponsor"][@"Twitter"] != nil);
    
    if (canEmail && canTwitter) {
        self.leftContactIcon.hidden = NO;
        self.rightContactIcon.hidden = NO;
        
        self.leftContactIcon.image = [UIImage imageNamed:@"smalltweet"];
        self.rightContactIcon.image = [UIImage imageNamed:@"smallmail"];
    } else if (canEmail) {
        self.leftContactIcon.hidden = YES;
        self.rightContactIcon.hidden = NO;
        
        self.rightContactIcon.image = [UIImage imageNamed:@"smallmail"];
    } else if (canTwitter) {
        self.leftContactIcon.hidden = YES;
        self.rightContactIcon.hidden = NO;
        
        self.rightContactIcon.image = [UIImage imageNamed:@"smalltweet"];
    } else {
        self.leftContactIcon.hidden = YES;
        self.rightContactIcon.hidden = YES;
    }
}

@end
