//
//  LoginViewController.m
//  HSHacks
//
//  Created by Spencer Yen on 2/7/14.
//  Copyright (c) 2014 hshacks.com. All rights reserved.
//

#import "SLoginViewController.h"
#import "SUpdatesViewController.h"
#import "SVProgressHUD/SVProgressHUD.h"

@implementation SLoginViewController

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    self.facebookButton.layer.cornerRadius = 5.0f;
    self.twitterButton.layer.cornerRadius = 5.0f;
    self.guestButton.layer.cornerRadius = 5.0f;
    
    CGRect logoDestFrame;
    CGRect twitterButtonDestFrame;
    CGRect facebookButtonDestFrame;
    CGRect guestButtonDestFrame;
    
    CGSize screenSize = [[UIScreen mainScreen] bounds].size;
    if (screenSize.height > 480.0f) {
        logoDestFrame = CGRectMake(self.logo.frame.origin.x + 30,
                                   self.logo.frame.origin.y - 90 + 30,
                                   self.logo.frame.size.width - 60,
                                   self.logo.frame.size.height - 60);
        twitterButtonDestFrame = CGRectMake(self.twitterButton.frame.origin.x,
                                            self.logo.frame.origin.y + 160,
                                            self.twitterButton.frame.size.width,
                                            self.twitterButton.frame.size.height);
        facebookButtonDestFrame = CGRectMake(self.facebookButton.frame.origin.x,
                                             self.logo.frame.origin.y + 240,
                                             self.facebookButton.frame.size.width,
                                             self.facebookButton.frame.size.height);
        guestButtonDestFrame = CGRectMake(self.guestButton.frame.origin.x,
                                          self.logo.frame.origin.y + 320,
                                          self.guestButton.frame.size.width,
                                          self.guestButton.frame.size.height);
    } else {
        logoDestFrame = CGRectMake(self.logo.frame.origin.x + 30,
                                   self.logo.frame.origin.y - 110 + 30,
                                   self.logo.frame.size.width - 60,
                                   self.logo.frame.size.height - 60);
        twitterButtonDestFrame = CGRectMake(self.twitterButton.frame.origin.x,
                                            self.logo.frame.origin.y + 115,
                                            self.twitterButton.frame.size.width,
                                            self.twitterButton.frame.size.height);
        facebookButtonDestFrame = CGRectMake(self.facebookButton.frame.origin.x,
                                             self.logo.frame.origin.y + 195,
                                             self.facebookButton.frame.size.width,
                                             self.facebookButton.frame.size.height);
        guestButtonDestFrame = CGRectMake(self.guestButton.frame.origin.x,
                                          self.logo.frame.origin.y + 275,
                                          self.guestButton.frame.size.width,
                                          self.guestButton.frame.size.height);
    }
    
    self.logo.alpha = 0.0;
    self.statusLabel.alpha = 0.0;
    
    [UIView animateWithDuration: 1.0f
                          delay: 0.0f
                        options: UIViewAnimationOptionCurveEaseIn
                     animations:^{
                         self.statusLabel.alpha = 1.0;
                     }
                     completion:^(BOOL finished){
                         [UIView animateWithDuration: 0.5f
                                               delay: 0.4f
                                             options: UIViewAnimationOptionCurveEaseIn
                                          animations:^{
                                              self.statusLabel.alpha = 0.0;
                                          }
                                          completion:^(BOOL finished){
                                              [UIView animateWithDuration: 0.5f
                                                                    delay: 0.0f
                                                                  options: UIViewAnimationOptionCurveEaseIn
                                                               animations:^{
                                                                   self.logo.alpha = 1.0;
                                                               }
                                                               completion:^(BOOL finished){
                                                                   [UIView animateWithDuration:1 animations:^{
                                                                       self.logo.frame = logoDestFrame;
                                                                       self.guestButton.frame = guestButtonDestFrame;
                                                                       self.facebookButton.frame = facebookButtonDestFrame;
                                                                       self.twitterButton.frame = twitterButtonDestFrame;
                                                                   }];
                                                                   
                                                               }];
                                              
                                          }];
                         
                     }];
    
}

- (IBAction)loginTwitter:(id)sender
{
    [SVProgressHUD showWithStatus:@"Logging in with Twitter..."];
    
    SKeysAccessor* keys = [SKeysAccessor singleton];
    [PFTwitterUtils initializeWithConsumerKey:[keys getTwitterConsumerKey] consumerSecret:[keys getTwitterConsumerSecret]];
    
    [PFTwitterUtils logInWithBlock:^(PFUser *user, NSError *error) {
        if (!user) {
            [SVProgressHUD dismiss];
            NSLog(@"Error %@",[error localizedDescription]);
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Login Error"
                                                            message:@"Twitter login failed"
                                                           delegate:nil
                                                  cancelButtonTitle:nil
                                                  otherButtonTitles:@"OK", nil];
            [alert show];
            return;
        } else {
            NSString *requestUrl = [NSString stringWithFormat:@"https://api.twitter.com/1.1/users/show.json?screen_name=%@", [PFTwitterUtils twitter].screenName];
            NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:requestUrl]];
            [[PFTwitterUtils twitter] signRequest:request];
            NSURLResponse *response = nil;
            NSData *data = [NSURLConnection sendSynchronousRequest:request
                                                 returningResponse:&response
                                                             error:&error];
            
            if (error == nil) {
                NSDictionary* twitterData = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
                
                if (error == nil) {
                    SUserData* userData = [SUserData sharedManager];
                    userData.isLoggedIn = YES;
                    userData.userName = [PFTwitterUtils twitter].screenName;
                    userData.userPhoto = twitterData[@"profile_image_url"];
                    
                    [self doneWithLogin];
                    return;
                }
            }
            
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Login Error"
                                                            message:@"Twitter login failed"
                                                           delegate:nil
                                                  cancelButtonTitle:nil
                                                  otherButtonTitles:@"OK", nil];
            [alert show];
            [SVProgressHUD dismiss];

        }
    }];
}

- (IBAction)loginFacebook:(id)sender
{
    [SVProgressHUD showWithStatus:@"Logging in with Facebook..."];
    
    NSArray *permissions = [[NSArray alloc] initWithObjects:
                            @"user_photos",
                            @"user_status",
                            nil];
    
    [PFFacebookUtils initializeFacebook];
    [PFFacebookUtils logInWithPermissions:permissions block:^(PFUser *user, NSError *error) {
        if (!user) {
            [SVProgressHUD dismiss];
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Login Error"
                                                            message:@"Facebook login failed"
                                                           delegate:nil
                                                  cancelButtonTitle:nil
                                                  otherButtonTitles:@"OK", nil];
            [alert show];
        } else {
            [self getFacebookData];
        }
    }];
}

- (void)getFacebookData
{
    if (FBSession.activeSession.isOpen) {
        [[FBRequest requestForMe] startWithCompletionHandler:^(FBRequestConnection *connection,NSDictionary<FBGraphUser> *user, NSError *error) {
             if (!error) {
                 SUserData *userData = [SUserData sharedManager];
                 userData.isLoggedIn = YES;
                 userData.userName = user.name;
                 userData.userPhoto = [NSString stringWithFormat:@"https://graph.facebook.com/%@/picture?type=square", user.username];

                 [self doneWithLogin];
             } else {
                 [SVProgressHUD dismiss];
                 UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Login Error"
                                                                 message:@"Facebook login failed"
                                                                delegate:nil
                                                       cancelButtonTitle:nil
                                                       otherButtonTitles:@"OK", nil];
                 [alert show];
                 
             }
         }];
    }
}

- (IBAction)loginGuest:(id)sender
{
    
}

- (void)doneWithLogin
{
    [SVProgressHUD dismiss];
    
    SUserData *userData = [SUserData sharedManager];
    userData.isLoggedIn = YES;
    
    dispatch_async(dispatch_get_main_queue(), ^{
        //make sure on main thread
        [UIView animateWithDuration: 1.0f
                              delay: 0.0f
                            options: UIViewAnimationOptionCurveEaseIn
                         animations:^{
                             self.logo.alpha = 0.0;
                             self.facebookButton.alpha = 0.0;
                             self.twitterButton.alpha = 0.0;
                             self.guestButton.alpha = 0.0;
                         }
                         completion:^(BOOL finished){
                             self.statusLabel.numberOfLines = 2;
                             self.statusLabel.lineBreakMode = NSLineBreakByWordWrapping;
                             self.statusLabel.text = [NSString stringWithFormat:@"Have a good time, %@", userData.userName];
                             [UIView animateWithDuration: 0.7f
                                                   delay: 0.0f
                                                 options: UIViewAnimationOptionCurveEaseIn
                                              animations:^{
                                                  self.statusLabel.alpha = 1.0;
                                              }
                                              completion:^(BOOL finished){
                                                  [self performSelector:@selector(dismissLoginView:) withObject:self afterDelay:1];
                                              }
                              ];
                         }];
    });
}

- (void)dismissLoginView:(id)sender
{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    SUpdatesViewController *updatesViewController = (SUpdatesViewController*)[storyboard instantiateViewControllerWithIdentifier:@"MainTabBar"];
    
    updatesViewController.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
    
    [self presentViewController:updatesViewController animated:YES completion:nil];
}

@end