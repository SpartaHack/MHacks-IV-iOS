//
//  MHMapViewController.m
//  MHacks
//
//  Created by Ben Oztalay on 8/31/14.
//  Copyright (c) 2014 hshacks.com. All rights reserved.
//

#import "MHMapViewController.h"

@implementation MHMapViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.mapView.region = MKCoordinateRegionMake(CLLocationCoordinate2DMake(42.290767548454689, -83.715561526486382), MKCoordinateSpanMake(0.0065224869222362258, 0.0065011960313228201));
}

@end
