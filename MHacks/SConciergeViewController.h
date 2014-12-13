//
//  ConciergeViewController.h
//  HSHacks
//
//  Created by Spencer Yen on 2/6/14.
//  Copyright (c) 2014 hshacks.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
#import <MessageUI/MessageUI.h>
#import "BOZPongRefreshControl.h"
#import "UIColor+SpartaHackColors.h"

@interface SConciergeViewController : UIViewController <MFMailComposeViewControllerDelegate, UIActionSheetDelegate>

@property (strong, nonatomic) NSMutableDictionary* sponsorUsers;
@property (strong, nonatomic) NSArray* sponsors;

@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) BOZPongRefreshControl *pongRefreshControl;

- (IBAction)drinkButtonTapped:(id)sender;
- (IBAction)foodButtonTapped:(id)sender;
- (IBAction)moreFood:(id)sender;

@end

