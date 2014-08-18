//
//  MHTabBar.m
//  HSHacks
//
//  Created by Bryce Dougherty on 8/17/14.
//  Copyright (c) 2014 hshacks.com. All rights reserved.
//

#import "MHTabBar.h"

@implementation MHTabBar

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
		//self.barTintColor = [UIColor blackColor];
		self.barStyle = UIBarStyleBlackTranslucent;
		self.opaque = NO;
		
		
		
		if ([self isIOS7OrHigher])
		{
			[[UITabBar appearance] setTintColor:[UIColor colorWithRed:1 green:0.47 blue:0 alpha:1]];
		}
		else
		{
			[[UITabBar appearance] setSelectedImageTintColor:[UIColor colorWithRed:1 green:0.47 blue:0 alpha:1]];
		}
        // Initialization code
    }
    return self;
}


- (BOOL)isIOS7OrHigher
{
    float versionNumber = floor(NSFoundationVersionNumber);
    return versionNumber > NSFoundationVersionNumber_iOS_6_1;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
