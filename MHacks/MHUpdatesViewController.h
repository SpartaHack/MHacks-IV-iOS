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
#import "UpdatesTableViewCell.h"


@interface MHUpdatesViewController : UIViewController

- (IBAction)postToFacebookTapped:(id)sender;
- (IBAction)postToTwitterTapped:(id)sender;


@property (weak, nonatomic) IBOutlet UITableView *tableView;


@end
