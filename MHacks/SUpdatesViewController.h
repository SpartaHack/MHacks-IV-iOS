//
//  UpdatesViewController.h
//  HSHacks
//
//  Created by Spencer Yen on 2/6/14.
//  Copyright (c) 2014 hshacks.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
#import "BOZPongRefreshControl.h"
#import "SUpdatesTableViewCell.h"
#import <Twitter/Twitter.h>

@interface SUpdatesViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UINavigationBar *bar;

- (IBAction)postToFacebookTapped:(id)sender;
- (IBAction)postToTwitterTapped:(id)sender;

@end
