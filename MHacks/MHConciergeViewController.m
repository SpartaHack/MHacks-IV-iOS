//
//  ConciergeViewController.m
//  HSHacks
//
//  Created by Spencer Yen on 2/6/14.
//  Copyright (c) 2014 hshacks.com. All rights reserved.
//

#import "MHConciergeViewController.h"
#import "MHConciergeTableViewCell.h"
#import <Social/Social.h>

@implementation MHConciergeViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self canIHazParseDatas:^{}];
}

- (void)canIHazParseDatas:(void(^)())block
{
    PFQuery *query = [PFUser query];
    [query whereKeyExists:@"sponsor"];
    [query includeKey:@"sponsor"];
    query.limit = 1000;
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            NSMutableArray* unsortedSponsors = [[NSMutableArray alloc] init];
            self.sponsorUsers = [[NSMutableDictionary alloc] init];
            
            for (PFObject* sponsorUser in objects) {
                PFObject* sponsor = sponsorUser[@"sponsor"];
                
                NSMutableArray* usersInSponsor = [self.sponsorUsers objectForKey:sponsor[@"title"]];
                if (usersInSponsor == nil) {
                    usersInSponsor = [[NSMutableArray alloc] init];
                    [self.sponsorUsers setObject:usersInSponsor forKey:sponsor[@"title"]];
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
    }];
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.sponsors.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[self.sponsorUsers objectForKey:[self.sponsors objectAtIndex:section][@"title"]] count];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return [self.sponsors objectAtIndex:section][@"title"];
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

    PFObject* sponsorUser = [[self.sponsorUsers objectForKey:[self.sponsors objectAtIndex:indexPath.section][@"title"]] objectAtIndex:indexPath.row];
    if (sponsorUser[@"email"] == nil) {
        UIAlertView *alert = [[UIAlertView alloc]
                              initWithTitle:@"No Email"
                              message:@"Looks like this person hasn't listed their email!"
                              delegate:nil
                              cancelButtonTitle:@"Aw come on"
                              otherButtonTitles:nil];
        [alert show];
        return;
    } else if (![MFMailComposeViewController canSendMail]) {
        UIAlertView *alert = [[UIAlertView alloc]
                              initWithTitle:@"Mail Not Set Up"
                              message:[NSString stringWithFormat:@"You can email %@ at %@", sponsorUser[@"name"], sponsorUser[@"email"]]
                              delegate:nil
                              cancelButtonTitle:@"Alright"
                              otherButtonTitles:nil];
        [alert show];
        return;
    }
    
    NSString *messageBody = [NSString stringWithFormat:@"Hey %@,", sponsorUser[@"name"]];
    NSArray *recipients = [NSArray arrayWithObject:sponsorUser[@"email"]];
    
    MFMailComposeViewController *mailViewController = [[MFMailComposeViewController alloc] init];
    mailViewController.mailComposeDelegate = self;
    [mailViewController setSubject:@"MHacks Help"];
    [mailViewController setMessageBody:messageBody isHTML:NO];
    [mailViewController setToRecipients:recipients];
    
    [self presentViewController:mailViewController animated:YES completion:NULL];
}

- (void) mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error
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

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *simpleTableIdentifier = @"ConciergeCell";
    
    MHConciergeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    if (cell == nil) {
        cell = [[MHConciergeTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
    }
    
    PFObject* sponsorUser = [[self.sponsorUsers objectForKey:[self.sponsors objectAtIndex:indexPath.section][@"title"]] objectAtIndex:indexPath.row];
    [cell setWithUser:sponsorUser];
    
    return cell;
}

- (IBAction)drinkButtonTapped:(id)sender {
    [self showTweetSheetWithMessage:@"Hey @mhacks, send beverages! I'm at "];
}

- (IBAction)foodButtonTapped:(id)sender {
    
    [self showTweetSheetWithMessage:@"Hey @mhacks, send food! I'm at "];
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

@end