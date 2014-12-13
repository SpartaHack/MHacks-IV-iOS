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
    
    self.mapView.region = MKCoordinateRegionMake(CLLocationCoordinate2DMake(42.290767548454689, -83.715561526486382), MKCoordinateSpanMake(0.0065224869222362258, 0.0065011960313228201));
    
    PFQuery* query = [PFQuery queryWithClassName:@"Venue"];
    query.limit = 1000;
    [query findObjectsInBackgroundWithBlock:^(NSArray* objects, NSError* error) {
        if (!error) {
            for (PFObject* venue in objects) {
                PFGeoPoint* center = venue[@"location"];
                MKPointAnnotation* annotation = [[MKPointAnnotation alloc] init];
                annotation.coordinate = CLLocationCoordinate2DMake(center.latitude, center.longitude);
                annotation.title = venue[@"title"];
                annotation.subtitle = venue[@"details"];
                [self.mapView addAnnotation:annotation];
            }
        } else {
            UIAlertView *alert = [[UIAlertView alloc]
                                  initWithTitle:@"Darn"
                                  message:@"Couldn't get the venues!"
                                  delegate:nil
                                  cancelButtonTitle:@"Seriously?"
                                  otherButtonTitles:nil];
            [alert show];
        }
    }];
}

@end
