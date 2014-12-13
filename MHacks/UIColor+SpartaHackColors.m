//
//  UIColor+SacksColors.m
//  Sacks
//
//  Created by Ben Oztalay on 8/27/14.
//  Copyright (c) 2014 hshacks.com. All rights reserved.
//

#import "UIColor+SpartaHackColors.m"

@implementation UIColor (SacksColors)

+ (UIColor*)datOrangeColor
{
    static UIColor* datOrange = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        datOrange = [UIColor colorWithRed:254.0/255.0 green:209.0/255.0 blue:54.0/255.0 alpha:1.0];
    });
    
    return datOrange;
}

+ (UIColor*)chatMessageCellEvenBackgroundColor
{
    static UIColor* chatMessageCellEvenBackground = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        chatMessageCellEvenBackground = [UIColor colorWithRed:189.0/255.0 green:195.0/255.0 blue:199.0/255.0 alpha:0.02];
    });
    
    return chatMessageCellEvenBackground;
}

+ (UIColor*)chatMessageCellOddBackgroundColor
{
    static UIColor* chatMessageCellOddBackground = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        chatMessageCellOddBackground = [UIColor colorWithRed:189.0/255.0 green:195.0/255.0 blue:199.0/255.0 alpha:0.08];
    });
    
    return chatMessageCellOddBackground;
}

@end
