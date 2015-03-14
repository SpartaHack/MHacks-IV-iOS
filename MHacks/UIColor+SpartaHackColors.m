//
//  UIColor+SacksColors.m
//  Sacks
//
//  Created by Ben Oztalay on 8/27/14.
//  Copyright (c) 2014 hshacks.com. All rights reserved.
//

#import "UIColor+SpartaHackColors.m"

@implementation UIColor (SacksColors)

+ (UIColor *)colorFromHexString:(NSString *)hexString {
    unsigned rgbValue = 0;
    NSScanner *scanner = [NSScanner scannerWithString:hexString];
    [scanner setScanLocation:1]; // bypass '#' character
    [scanner scanHexInt:&rgbValue];
    return [UIColor colorWithRed:((rgbValue & 0xFF0000) >> 16)/255.0 green:((rgbValue & 0xFF00) >> 8)/255.0 blue:(rgbValue & 0xFF)/255.0 alpha:1.0];
}

+ (UIColor*)segColor{
    static UIColor* segColor = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        segColor = [UIColor colorFromHexString:@"#D8BCA7"];
    });
    
    return segColor;
}

+ (UIColor*)datPrimaryColor
{
    static UIColor* datPrimary = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        datPrimary = [UIColor colorFromHexString:@"#3F332B"];
    });
    
    return datPrimary;
}

+ (UIColor*)navIconTintColor{
    
    static UIColor* navIconTintColor = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        navIconTintColor = [UIColor colorFromHexString:@"#CC9548"];
    });
    
    return navIconTintColor;
}

+ (UIColor*)p1Color{
    static UIColor* datP1Color = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        datP1Color = [UIColor colorFromHexString:@"#F49C3A"];
    });
    
    return datP1Color;
}

+ (UIColor*)p2Color{
    static UIColor* datP2Color = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        datP2Color = [UIColor colorFromHexString:@"#5D4F43"];
    });
    
    return datP2Color;
}

+ (UIColor*)p3Color{
    static UIColor* datP3Color = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        datP3Color = [UIColor colorFromHexString:@"#D8BCA7"];
    });
    
    return datP3Color;
}

// Chat colors not used in the SpartaHack App

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
