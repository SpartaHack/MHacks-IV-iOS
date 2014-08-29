//
//  MHKeysAccessor.m
//  MHacks
//
//  Created by Ben Oztalay on 8/28/14.
//  Copyright (c) 2014 hshacks.com. All rights reserved.
//

#import "MHKeysAccessor.h"

@implementation MHKeysAccessor

+ (MHKeysAccessor*)singleton
{
    static MHKeysAccessor *keysAccessor = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        keysAccessor = [[MHKeysAccessor alloc] init];
    });
    
    return keysAccessor;
}

- (id)init
{
    self = [super init];
    if (self) {
        self.keysPlist = [NSDictionary dictionaryWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"appKeys" ofType:@"plist"]];
    }
    return self;
}
- (NSString*)getParseAppId
{
    return self.keysPlist[@"parseAppId"];
}

- (NSString*)getParseConsumerKey
{
    return self.keysPlist[@"parseClientKey"];
}

- (NSString*)getTwitterConsumerKey
{
    return self.keysPlist[@"twitterConsumerKey"];
}

- (NSString*)getTwitterConsumerSecret
{
    return self.keysPlist[@"twitterConsumerSecret"];
}

@end
