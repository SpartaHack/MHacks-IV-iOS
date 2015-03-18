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
    self.mapWebView.delegate = self;
    NSString *pdfURL = @"http://spartahack.com/venue-ios";
    NSURL *targetURL = [NSURL URLWithString:pdfURL];
    NSURLRequest *request = [NSURLRequest requestWithURL:targetURL];
    [self.mapWebView loadRequest:request];
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error{
    if (error) {
        NSString *pdfURL = [[NSBundle mainBundle] pathForResource:@"ios-map" ofType:@"pdf"];
        NSURL *targetURL = [NSURL URLWithString:pdfURL];
        NSURLRequest *request = [NSURLRequest requestWithURL:targetURL];
        [self.mapWebView loadRequest:request];
    }
}

- (void)webViewDidFinishLoad:(UIWebView *)webView{
    self.mapText.hidden = YES;
}
@end
