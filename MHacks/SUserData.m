//
//  UserData.m
//  HSHacks
//
//  Created by Spencer Yen on 2/7/14.
//  Copyright (c) 2014 hshacks.com. All rights reserved.
//

#import "SUserData.h"

@interface SUserData ()

@property (strong, nonatomic) NSUserDefaults* userDefaults;

@end

@implementation SUserData

#pragma mark - Init

+ (SUserData*)sharedManager {
    static SUserData *userData = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        userData = [[SUserData alloc] init];
    });
    
    return userData;
}

- (id)init
{
    self = [super init];
    if (self) {
        self.userDefaults = [NSUserDefaults standardUserDefaults];
    }
    return self;
}

- (void)dealloc
{
    [self.userDefaults synchronize];
}

#pragma mark - isLoggedIn

static NSString* kIsLoggedInKey = @"LoggedIn";

- (void)setIsLoggedIn:(BOOL)isLoggedIn
{
    [self.userDefaults setBool:isLoggedIn forKey:kIsLoggedInKey];
}

- (BOOL)isLoggedIn
{
    return [self.userDefaults boolForKey:kIsLoggedInKey];
}

#pragma mark - userName

static NSString* kUserNameKey = @"userName";

- (void)setUserName:(NSString *)userName
{
    [self.userDefaults setObject:userName forKey:kUserNameKey];
}

- (NSString*)userName
{
    return [self.userDefaults stringForKey:kUserNameKey];
}

#pragma mark - userPhoto

static NSString* kUserPhotoKey = @"userPhoto";

- (void)setUserPhoto:(NSString *)userPhoto
{
    [self.userDefaults setObject:userPhoto forKey:kUserPhotoKey];
}

- (NSString*)userPhoto
{
    return [self.userDefaults stringForKey:kUserPhotoKey];
}

@end
