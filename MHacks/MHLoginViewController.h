//
//  LoginViewController.h
//  HSHacks
//
//  Created by Spencer Yen on 2/7/14.
//  Copyright (c) 2014 hshacks.com. All rights reserved.
///Users/aakash/Dropbox/Spencer/hshacks-ios/HSHacks/userNameViewController.h

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
#import <ParseFacebookUtils/PFFacebookUtils.h>
#import "MHUserData.h"
#import "MHKeysAccessor.h"
#import <QuartzCore/QuartzCore.h>

@interface MHLoginViewController : UIViewController

- (IBAction)loginTwitter:(id)sender;
- (IBAction)loginFacebook:(id)sender;
- (IBAction)loginGuest:(id)sender;

@property (strong, nonatomic) NSString *username;

@property (strong, nonatomic) IBOutlet UIImageView *logo;
@property (strong, nonatomic) IBOutlet UIButton *twitterButton;
@property (strong, nonatomic) IBOutlet UIButton *facebookButton;
@property (strong, nonatomic) IBOutlet UIButton *guestButton;
@property (strong, nonatomic) IBOutlet UILabel *statusLabel;


@end
