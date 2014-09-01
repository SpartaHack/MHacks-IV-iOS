//
//  GuideViewController.m
//  HSHacks
//
//  Created by Aakash Thumaty on 2/16/14.
//  Copyright (c) 2014 hshacks.com. All rights reserved.
//

#import "MHGuideViewController.h"
#import "UIColor+MHacksColors.h"

@implementation MHGuideViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //Wat.
    UIScrollView *scroll = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, 320, 64)];
    scroll.contentSize = CGSizeMake(320, 44);
    scroll.showsHorizontalScrollIndicator = NO;
    
    NSArray *itemArray = [NSArray arrayWithObjects: @"Schedule", @"Map", @"Awards",  nil];
    UISegmentedControl *segmentedControl = [[UISegmentedControl alloc] initWithItems:itemArray];
    segmentedControl.frame = CGRectMake(55,25,210,30); //WAt
    segmentedControl.tintColor = [UIColor datOrangeColor];
    [segmentedControl addTarget:self action:@selector(changeView:)
                  forControlEvents:UIControlEventValueChanged];

    segmentedControl.selectedSegmentIndex = 0;
    [scroll addSubview:segmentedControl];
    
    [self.view addSubview:scroll];
    
    self.awardsContainer.hidden = YES;
    self.scheduleContainer.hidden = NO;
    self.countdownContainer.hidden = NO;
    self.mapContainer.hidden = YES;
    
    [self.view bringSubviewToFront:_scheduleContainer];
    [self.view bringSubviewToFront:_countdownContainer];
}

- (void)changeView:(id)sender
{
    UISegmentedControl *segmentedControl = (UISegmentedControl *) sender;
    NSInteger selectedSegment = segmentedControl.selectedSegmentIndex;
    
    if (selectedSegment == 0) {
        //Show schedule
        self.awardsContainer.hidden = YES;
        self.scheduleContainer.hidden = NO;
        self.countdownContainer.hidden = NO;
        self.mapContainer.hidden = YES;
        
        [self.view bringSubviewToFront:self.scheduleContainer];
        [self.view bringSubviewToFront:self.countdownContainer];
    } else if (selectedSegment == 1) {
        self.awardsContainer.hidden = YES;
        self.scheduleContainer.hidden = YES;
        self.countdownContainer.hidden = YES;
        self.mapContainer.hidden = NO;
        
        [self.view bringSubviewToFront:self.mapContainer];
    } else if (selectedSegment == 2) {
        //Show Awards
        self.awardsContainer.hidden = NO;
        self.scheduleContainer.hidden = YES;
        self.countdownContainer.hidden = YES;
        self.mapContainer.hidden = YES;
        
        [self.view bringSubviewToFront:self.awardsContainer];
        
    }
}

@end
