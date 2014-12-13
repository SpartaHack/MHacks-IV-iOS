//
//  UIResponder+FirstResponder.h
//  Sacks
//
//  Created by Ben Oztalay on 12/1/13.
//  Copyright (c) 2013 Sacks. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIResponder (FirstResponder)

+ (id)currentFirstResponder;

@end
