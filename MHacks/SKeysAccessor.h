//
//  SKeysAccessor.h
//  Sacks
//
//  Created by Ben Oztalay on 8/28/14.
//  Copyright (c) 2014 hshacks.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SKeysAccessor : NSObject

@property (strong, nonatomic) NSDictionary* keysPlist;

+ (SKeysAccessor*)singleton;

- (NSString*)getParseAppId;
- (NSString*)getParseConsumerKey;

- (NSString*)getTwitterConsumerKey;
- (NSString*)getTwitterConsumerSecret;

@end
