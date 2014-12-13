//
//  UserData.h
//  HSHacks
//
//  Created by Spencer Yen on 2/7/14.
//  Copyright (c) 2014 hshacks.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SUserData : NSObject

@property (nonatomic) BOOL isLoggedIn;
@property (strong, nonatomic) NSString *userName;
@property (strong, nonatomic) NSString *userPhoto;

+ (SUserData*)sharedManager;

@end
