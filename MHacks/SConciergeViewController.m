//
//  ConciergeViewController.m
//  HSHacks
//
//  Created by Spencer Yen on 2/6/14.
//  Copyright (c) 2014 hshacks.com. All rights reserved.
//

#import "SConciergeViewController.h"
#import "SConciergeTableViewCell.h"
#import <Social/Social.h>

@interface SConciergeViewController ()
{
    PFUser* sponsorUserToContact;
    UIWebView* webView;
}
@end

@implementation SConciergeViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self canIHazParseDatas:^{}];
}

- (void)canIHazParseDatas:(void(^)())block
{
    PFQuery *sponsorQuery = [PFQuery queryWithClassName:@"Concierge"];
    [sponsorQuery includeKey:@"Sponsor"];
    [sponsorQuery orderByAscending:@"Name"];
    sponsorQuery.limit = 1000;
    [sponsorQuery findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            NSMutableArray* unsortedSponsors = [[NSMutableArray alloc] init];
            self.sponsorUsers = [[NSMutableDictionary alloc] init];
            
            for (PFObject* sponsorUser in objects) {
                PFObject* sponsor = sponsorUser[@"Sponsor"];

                NSMutableArray* usersInSponsor = [self.sponsorUsers objectForKey:sponsor[@"Title"]];
                if (usersInSponsor == nil) {
                    usersInSponsor = [[NSMutableArray alloc] init];
                    [self.sponsorUsers setObject:usersInSponsor forKey:sponsor[@"Title"]];
                    [unsortedSponsors addObject:sponsor];
                }
                
                [usersInSponsor addObject:sponsorUser];
            }
            
            self.sponsors = [unsortedSponsors sortedArrayUsingComparator:^NSComparisonResult(PFObject* a, PFObject* b) {
                return [a[@"ordering"] integerValue] > [b[@"ordering"] integerValue];
            }];
        } else {
            UIAlertView *alert = [[UIAlertView alloc]
                                  initWithTitle:@"Oops!"
                                  message:@"Couldn't load sponsor data."
                                  delegate:nil
                                  cancelButtonTitle:@"Dismiss"
                                  otherButtonTitles:nil];
            [alert show];
        }

        [self.tableView reloadData];
        block(nil,nil);
    }];
}

#pragma mark PONG PONG PONG

- (void)viewDidLayoutSubviews
{
    self.pongRefreshControl = [BOZPongRefreshControl attachToTableView:self.tableView
                                                     withRefreshTarget:self
                                                      andRefreshAction:@selector(refreshTriggered)];
    self.pongRefreshControl.backgroundColor = [UIColor datOrangeColor];
	[super viewDidLayoutSubviews];
}

- (void)refreshTriggered
{
    //Go and load some data
    [self canIHazParseDatas:^{
        [self.pongRefreshControl finishedLoading];
    }];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [self.pongRefreshControl scrollViewDidScroll];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    [self.pongRefreshControl scrollViewDidEndDragging];
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.sponsors.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[self.sponsorUsers objectForKey:[self.sponsors objectAtIndex:section][@"Title"]] count];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return [self.sponsors objectAtIndex:section][@"Title"];
}

#pragma mark - UITableViewDelegate

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *simpleTableIdentifier = @"ConciergeCell";
    
    SConciergeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    if (cell == nil) {
        cell = [[SConciergeTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
    }
    
    PFObject* sponsorUser = [[self.sponsorUsers objectForKey:[self.sponsors objectAtIndex:indexPath.section][@"Title"]] objectAtIndex:indexPath.row];
    [cell setWithUser:sponsorUser];

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

    PFUser* sponsorUser = [[self.sponsorUsers objectForKey:[self.sponsors objectAtIndex:indexPath.section][@"Title"]] objectAtIndex:indexPath.row];
    BOOL canEmail = (sponsorUser[@"Sponsor"][@"email"] != nil);
    BOOL canTwitter = (sponsorUser[@"Sponsor"][@"Twitter"] != nil);
    
    if (canEmail && canTwitter) {
        [self showContactActionSheetForUser:sponsorUser];
    } else if (canEmail) {
        [self emailUser:sponsorUser];
    } else if (canTwitter) {
        [self tweetUser:sponsorUser];
    }
}

- (void)showContactActionSheetForUser:(PFUser*)sponsorUser
{
    sponsorUserToContact = sponsorUser;
    UIActionSheet* contactSheet = [[UIActionSheet alloc] initWithTitle:[NSString stringWithFormat:@"Contact %@", sponsorUser[@"Sponsor"][@"Name"]]
                                                              delegate:self
                                                     cancelButtonTitle:@"Nevermind"
                                                destructiveButtonTitle:nil
                                                     otherButtonTitles:@"Tweet", @"Email", nil];
    [contactSheet showInView:[UIApplication sharedApplication].keyWindow];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {
        [self tweetUser:sponsorUserToContact];
    } else if (buttonIndex == 1) {
        [self emailUser:sponsorUserToContact];
    }
}

- (void)emailUser:(PFUser*)sponsorUser
{
    if (![MFMailComposeViewController canSendMail]) {
        UIAlertView *alert = [[UIAlertView alloc]
                              initWithTitle:@"Mail Not Set Up"
                              message:[NSString stringWithFormat:@"You can email %@ at %@", sponsorUser[@"Sponsor"][@"Name"], sponsorUser[@"Sponsor"][@"email"]]
                              delegate:nil
                              cancelButtonTitle:@"Alright"
                              otherButtonTitles:nil];
        [alert show];
        return;
    }
    
    NSString *messageBody = [NSString stringWithFormat:@"Hey %@,", sponsorUser[@"Sponsor"][@"Name"]];
    NSArray *recipients = [NSArray arrayWithObject:sponsorUser[@"Sponsor"][@"email"]];
    
    MFMailComposeViewController *mailViewController = [[MFMailComposeViewController alloc] init];
    mailViewController.mailComposeDelegate = self;
    [mailViewController setSubject:@"SpartaHack Help"];
    [mailViewController setMessageBody:messageBody isHTML:NO];
    [mailViewController setToRecipients:recipients];
    
    [self presentViewController:mailViewController animated:YES completion:NULL];
}

- (void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error
{
    if (result == MFMailComposeResultFailed) {
        UIAlertView *alert = [[UIAlertView alloc]
                              initWithTitle:@"Email Failed"
                              message:@"Something went wrong sending your email!"
                              delegate:nil
                              cancelButtonTitle:@"Ugh"
                              otherButtonTitles:nil];
        [alert show];
    }
    
    [self dismissViewControllerAnimated:YES completion:NULL];
}

- (void)tweetUser:(PFUser*)sponsorUser
{
    NSString* twitterHandle = sponsorUser[@"Sponsor"][@"Twitter"];
    if ([twitterHandle characterAtIndex:0] == '@') {
        twitterHandle = [twitterHandle substringFromIndex:1];
    }
    
    NSString* tweetMessage = [NSString stringWithFormat:@"Hey @%@, ", twitterHandle];
    [self showTweetSheetWithMessage:tweetMessage];
}

- (void)showTweetSheetWithMessage:(NSString*)message
{
    if ([SLComposeViewController isAvailableForServiceType:SLServiceTypeTwitter]) {
        SLComposeViewController *tweetSheet = [SLComposeViewController
                                               composeViewControllerForServiceType:SLServiceTypeTwitter];
        [tweetSheet setInitialText:message];
        [self presentViewController:tweetSheet animated:YES completion:nil];
    } else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Oops"
                                                        message:@"Looks like you don't have a Twitter account linked to this device."
                                                       delegate:self
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
    }
}

# pragma mark - Food

- (IBAction)drinkButtonTapped:(id)sender
{
    [self showTweetSheetWithMessage:@"Hey @SpartaHack, send drinks! I'm at "];
}

- (IBAction)foodButtonTapped:(id)sender
{
    [self showTweetSheetWithMessage:@"Hey @SpartaHack, send food! I'm at "];
}

- (IBAction)moreFood:(id)sender
{
    if (webView == nil) {
        webView = [[UIWebView alloc] initWithFrame:CGRectMake(-10.0, -10.0f, 5.0f, 5.0f)];
        webView.mediaPlaybackRequiresUserAction = NO;
        [self.view addSubview:webView];
    }
    
    static NSString *videoHTML = @"<!DOCTYPE html><html><head><style>body{margin:0px 0px 0px 0px;}</style></head> <body> <div id=\"player\"></div> <script> var tag = document.createElement('script'); tag.src = \"http://www.youtube.com/player_api\"; var firstScriptTag = document.getElementsByTagName('script')[0]; firstScriptTag.parentNode.insertBefore(tag, firstScriptTag); var player; function onYouTubePlayerAPIReady() { player = new YT.Player('player', { width:'%0.0f', height:'%0.0f', videoId:'%@', events: { 'onReady': onPlayerReady, } }); } function onPlayerReady(event) { event.target.playVideo(); } </script> </body> </html>";
    [webView loadHTMLString:[NSString stringWithFormat:videoHTML, webView.frame.size.width, webView.frame.size.height, @"ecc0nbg9m-8"] baseURL:[[NSBundle mainBundle] resourceURL]];
}

@end