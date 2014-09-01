//
//  ScheduleViewController.h
//  HSHacks
//
//  Created by Spencer Yen on 2/17/14.
//  Copyright (c) 2014 hshacks.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
#import "BOZPongRefreshControl.h"
#import "UIColor+MHacksColors.h"

@interface MHScheduleViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, retain) NSMutableArray *days;
@property (nonatomic, retain) NSMutableDictionary *eventsByDay;

@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) BOZPongRefreshControl *pongRefreshControl;

@end
