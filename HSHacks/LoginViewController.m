//
//  LoginViewController.m
//  HSHacks
//
//  Created by Spencer Yen on 2/7/14.
//  Copyright (c) 2014 hshacks.com. All rights reserved.
//

#import "LoginViewController.h"
#import "LoggedInViewController.h"

@interface LoginViewController ()



@end

@implementation LoginViewController

@synthesize username, logo, statusLabel, twitterButton, facebookButton, guestButton;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    
    

}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    logo.alpha = 0.0;
    statusLabel.alpha = 0.0;
    
    [UIView animateWithDuration: 1.0f
                          delay: 0.5f
                        options: UIViewAnimationOptionCurveEaseIn
                     animations:^{
                         statusLabel.alpha = 1.0;
                     }
                     completion:^(BOOL finished){
                         [UIView animateWithDuration:1.0f animations:^{ statusLabel.alpha = 0.0; }];
                     }
     ];
    
    CGRect logoF = CGRectMake(logo.frame.origin.x,logo.frame.origin.y-100,logo.frame.size.width-60,logo.frame.size.height-60);
    CGRect tbuttonF = CGRectMake(twitterButton.frame.origin.x,twitterButton.frame.origin.y-240,twitterButton.frame.size.width,twitterButton.frame.size.height);
    CGRect fButtonF = CGRectMake(facebookButton.frame.origin.x,facebookButton.frame.origin.y-170,facebookButton.frame.size.width,facebookButton.frame.size.height);
    CGRect gButtonF = CGRectMake(guestButton.frame.origin.x,guestButton.frame.origin.y-100,guestButton.frame.size.width,guestButton.frame.size.height);


    [UIView animateWithDuration: 1.0f
                          delay: 2.0f
                        options: UIViewAnimationOptionCurveEaseIn
                     animations:^{
                         logo.alpha = 1.0;
                     }
                     completion:^(BOOL finished){
                         [UIView animateWithDuration:1 animations:^{
                             logo.frame = logoF;
                             guestButton.frame = gButtonF;
                             facebookButton.frame = fButtonF;
                             twitterButton.frame = tbuttonF;
                         }];

                     }
     ];
    
}

-(void)loginTwitter{
    
    NSArray *permissions = [[NSArray alloc] initWithObjects:
                            @"user_photos",
                            @"user_status",
                            nil];

    
    
    if ([TWTweetComposeViewController canSendTweet])
    {
        [self getTInfo];
    }
    else{
        //show tweeet login prompt to user to login
        TWTweetComposeViewController *viewController = [[TWTweetComposeViewController alloc] init];
        
        //hide the tweet screen
        viewController.view.hidden = YES;
        
        //fire tweetComposeView to show "No Twitter Accounts" alert view on iOS5.1
        viewController.completionHandler = ^(TWTweetComposeViewControllerResult result) {
            if (result == TWTweetComposeViewControllerResultCancelled) {
                [self dismissModalViewControllerAnimated:NO];
            }
        };
        [self presentModalViewController:viewController animated:NO];
        
        //hide the keyboard
        [viewController.view endEditing:YES];
        
        [self getTInfo];

    }

}


- (void) getTInfo
{
    
    // Request access to the Twitter accounts

    
    
    ACAccountStore *accountStore = [[ACAccountStore alloc] init];
    ACAccountType *accountType = [accountStore accountTypeWithAccountTypeIdentifier:ACAccountTypeIdentifierTwitter];
    
    [accountStore requestAccessToAccountsWithType:accountType options:nil completion:^(BOOL granted, NSError *error){
        if (granted) {
            
            NSArray *accountsArray = [accountStore accountsWithAccountType:accountType];
            
            
            
            // Check if the users has setup at least one Twitter account
            
            if ([accountsArray count] > 0)
            {
                
                ACAccount *twitterAccount = [accountsArray objectAtIndex:0];
                NSLog(@"The following person is absolute poo: %@",twitterAccount.username);
      
                // Creating a request to get the info about a user on Twitter
                
                SLRequest *twitterInfoRequest = [SLRequest requestForServiceType:SLServiceTypeTwitter requestMethod:SLRequestMethodGET URL:[NSURL URLWithString:@"https://api.twitter.com/1.1/users/show.json"] parameters:[NSDictionary dictionaryWithObject:twitterAccount.username forKey:@"screen_name"]];
                
                TWRequest *request = [[TWRequest alloc] initWithURL:[NSURL URLWithString:@"https://api.twitter.com/1.1/users/show.json"]
                                                         parameters:[NSDictionary dictionaryWithObject:twitterAccount.username forKey:@"screen_name"]
                                                      requestMethod:TWRequestMethodGET];
        
                // Making the request
   
                [request performRequestWithHandler:^(NSData *responseData, NSHTTPURLResponse *urlResponse, NSError *error) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        
                        // Check if we reached the reate limit
                        
                        if ([urlResponse statusCode] == 429) {
                            NSLog(@"Rate limit reached");
                            return;
                        }
                        
                        // Check if there was an error
                        
                        if (error) {
                            NSLog(@"Error: %@", error.localizedDescription);
                            return;
                        }
                        
                        // Check if there is some response data
                        
                        if (responseData) {
                            
                            NSError *error = nil;
                            NSDictionary *TWData = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingAllowFragments error:&error];
                           
                            
                            NSDictionary *user =
                            [NSJSONSerialization JSONObjectWithData:responseData
                                                            options:NSJSONReadingAllowFragments
                                                              error:NULL];
                            
                            NSString *name = [user objectForKey:@"name"];
                            NSString *profileImageStringURL = [user objectForKey:@"profile_image_url"];
                            NSLog(@"twitter image: %@", profileImageStringURL);
                            
                            UserData *userData = [UserData sharedManager];
                            userData.userName = name;
                            NSLog(@"userdata.username: %@",userData.userName);

                            userData.userPhoto = profileImageStringURL;
                            NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];

                            [defaults setObject:userData.userName forKey:@"name"];
                            [defaults setObject:userData.userPhoto forKey:@"photo"];
                            
                            [defaults synchronize];
          

                           [self doneWithLogin];
  
                            

                    
                        }
                    });
                }];
            }
        } else {
            NSLog(@"No access granted");
        }
    }];
}


-(void)testTwittter{
    NSURL *url =
    [NSURL URLWithString:@"http://api.twitter.com/1/users/show.json"];
    
    NSDictionary *params = [NSDictionary dictionaryWithObject:@"spenciefy"
                                                       forKey:@"screen_name"];
    
    TWRequest *request = [[TWRequest alloc] initWithURL:url
                                             parameters:params
                                          requestMethod:TWRequestMethodGET];
    
    [request performRequestWithHandler:
     ^(NSData *responseData, NSHTTPURLResponse *urlResponse, NSError *error) {
         if (responseData) {
             NSDictionary *user =
             [NSJSONSerialization JSONObjectWithData:responseData
                                             options:NSJSONReadingAllowFragments
                                               error:NULL];
             
             NSString *profileImageUrl = [user objectForKey:@"profile_image_url"];
             
             NSLog(@"url: %@", profileImageUrl);
         }
     }];
}
-(void)loginFacebook{
    //Login to Facebook to get name, photo
    
    NSArray *permissions = [[NSArray alloc] initWithObjects:
                            @"user_photos",
                            @"user_status",
                            nil];
    
    NSLog(@"called login facebook");
    
       [FBSession openActiveSessionWithReadPermissions:permissions
                                       allowLoginUI:YES
                                  completionHandler:^(FBSession *session,
                                                      FBSessionState state,
                                                      NSError *error) {
                                      
                                      if(!error){
                                          NSLog(@"Facebook connected");
                                          [self getFacebookData];
                                      }
                                      if(error){
                                          
                                          NSLog(@"Error in fb auth request: %@", error.localizedDescription);
                                          UIAlertView *alert = [[UIAlertView alloc] initWithTitle: @"Oops." message: @"Something went wrong with Facebook." delegate: nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                                          [alert show];
                                          
                                      }
                                      
                                  }];
    
}

-(void)getFacebookData{
    if (FBSession.activeSession.isOpen) {
        [[FBRequest requestForMe] startWithCompletionHandler:
         ^(FBRequestConnection *connection,
           NSDictionary<FBGraphUser> *user,
           NSError *error) {
             if (!error) {
                 NSLog(@"facebook username %@", user.name);
                 
                 UserData *userData = [UserData sharedManager];
                 userData.userName = user.name;
                   NSString *photo = [NSString stringWithFormat:@"https://graph.facebook.com/%@/picture?type=square", user.username];
                 NSLog(@"facebook pic: %@", photo);
                 userData.userPhoto = photo;
                 
                 //now store data in nsuserdefault
                 NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
      
                 
                 [defaults setObject:userData.userName forKey:@"name"];
                 [defaults setObject:userData.userPhoto forKey:@"photo"];
                 
                 [defaults synchronize];
                 
                 //should show animations and user info
                 [self doneWithLogin];
                 
             }
             if(error){
                 NSLog(@"Error in FB API request: %@", error.localizedDescription);
                 UIAlertView *alert = [[UIAlertView alloc] initWithTitle: @"Oops." message: @"Something went wrong with Facebook." delegate: nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                 [alert show];
                 
             }
         }];
        
        
    }
    
    
}



- (IBAction)loginTwitter:(id)sender {
    [self loginTwitter];
}

- (IBAction)loginFacebook:(id)sender {
        [self loginFacebook];
}

- (IBAction)loginGuest:(id)sender {
    
    
}

-(void)doneWithLogin{
    //Method to push controller to updates
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    

    [defaults setObject:@"YES" forKey:@"loggedIn"];
    [[NSUserDefaults standardUserDefaults] synchronize];

    //show "Have a good time, <name>"
    
    //1. shift logo to center of screen, start to fade out
    //2. When logo starts to fade out, fade in "Have a good time, <name>" on top of the image (logo still fading out).
    //3. After text fades in, dismiss the view.
    
    [self dismissModalViewControllerAnimated:YES];
    
}


@end
