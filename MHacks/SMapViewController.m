//
//  SMapViewController.m
//  Sacks
//
//  Created by Ben Oztalay on 8/31/14.
//  Copyright (c) 2014 hshacks.com. All rights reserved.
//

#import "SMapViewController.h"
#import <Parse/Parse.h>

@implementation SMapViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    NSString *path = [[NSBundle mainBundle] pathForResource:@"hacker-floor-plan" ofType:@"pdf"];
    NSURL *targetURL = [NSURL fileURLWithPath:path];
    NSURLRequest *request = [NSURLRequest requestWithURL:targetURL];
    [self.mapWebView loadRequest:request];
    
}

@end
