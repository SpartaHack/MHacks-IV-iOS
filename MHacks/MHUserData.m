//
//  UserData.m
//  HSHacks
//
//  Created by Spencer Yen on 2/7/14.
//  Copyright (c) 2014 hshacks.com. All rights reserved.
//

#import "MHUserData.h"

@interface MHUserData ()

@property (strong, nonatomic) NSUserDefaults* userDefaults;

@end

@implementation MHUserData

#pragma mark - Init

+ (id)sharedManager {
    static MHUserData *userData = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        userData = [[self alloc] init];
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

#pragma mark - isLoggedIn

static NSString* kIsLoggedInKey = @"isLoggedIn";

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
