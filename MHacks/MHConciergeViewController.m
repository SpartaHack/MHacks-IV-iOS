//
//  ConciergeViewController.m
//  HSHacks
//
//  Created by Spencer Yen on 2/6/14.
//  Copyright (c) 2014 hshacks.com. All rights reserved.
//

#import "MHConciergeViewController.h"
#import <MessageUI/MessageUI.h>
#import <Social/Social.h>
@interface MHConciergeViewController () <MFMailComposeViewControllerDelegate,MFMessageComposeViewControllerDelegate>

@end

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

- (void) mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error
{
    switch (result)
    {
        case MFMailComposeResultCancelled:
            NSLog(@"Mail cancelled");
            break;
        case MFMailComposeResultSaved:
            NSLog(@"Mail saved");
            break;
        case MFMailComposeResultSent:{
            NSLog(@"Mail sent");
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle: @"Horray!" message: @"Your email was sent!" delegate: nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alert show];
        }
        case MFMailComposeResultFailed:{
            NSLog(@"Mail sent failure: %@", [error localizedDescription]);
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle: @"Hm..." message: @"Something went wrong. Try sending the email again." delegate: nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alert show];
        }
            break;
        default:
            break;
    }
    
    // Close the Mail Interface
    [self dismissViewControllerAnimated:YES completion:NULL];
}

- (void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult) result
{
    switch (result) {
        case MessageComposeResultCancelled:
            break;
            
        case MessageComposeResultFailed:
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle: @"Hm..." message: @"Something wnet wrong. Try sending the text again." delegate: nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alert show];
            break;
        }
            
        case MessageComposeResultSent:{
        
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle: @"Horray!" message: @"Your text was sent!" delegate: nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alert show];
        }
            break;
            
        default:
            break;
    }
    
    [self dismissViewControllerAnimated:YES completion:nil];
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
//    // Email Subject
//    NSString *emailTitle = @"Test Email";
//    // Email Content
//    NSString *messageBody = [NSString stringWithFormat:@"Hey %@,", [arrayOfCompanies objectAtIndex:indexPath.section]];
//    NSArray *sendArray = [NSArray arrayWithObject:[arrayOfCompanies objectAtIndex:indexPath.section]];
//    MFMailComposeViewController *mc = [[MFMailComposeViewController alloc] init];
//    mc.mailComposeDelegate = self;
//    [mc setSubject:emailTitle];
//    [mc setSubject:@"MHacks Help"];
//    [mc setMessageBody:messageBody isHTML:NO];
//    [mc setToRecipients:sendArray];
//    
//    // Present mail view controller on screen
//    [self presentViewController:mc animated:YES completion:NULL];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *simpleTableIdentifier = @"ConciergeCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
    }
    
    cell.textLabel.text = [[self.sponsorUsers objectForKey:[self.sponsors objectAtIndex:indexPath.section][@"title"]] objectAtIndex:indexPath.row][@"name"];
    
    return cell;
}

- (IBAction)postToFacebookTapped:(id)sender {
    if ([SLComposeViewController isAvailableForServiceType:SLServiceTypeFacebook]){
        SLComposeViewController *composeController = [SLComposeViewController
                                                      composeViewControllerForServiceType:SLServiceTypeFacebook];
        
        [composeController setInitialText:@"Check out the Mhacks hackathon!"];
        //Post actual selfie?
        [self presentViewController:composeController
                           animated:YES completion:nil];
    }
    else{
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Oops"
                                                        message:@"Looks like you don't have a Facebook account linked to this device."
                                                       delegate:self
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
    }
}

- (IBAction)postToTwitterTapped:(id)sender {
    if ([SLComposeViewController isAvailableForServiceType:SLServiceTypeTwitter])
    {
        SLComposeViewController *tweetSheet = [SLComposeViewController
                                               composeViewControllerForServiceType:SLServiceTypeTwitter];
        NSString *message = [NSString stringWithFormat:@"Check out the @MHacks hackathon!"];
        [tweetSheet setInitialText:message];
        [self presentViewController:tweetSheet animated:YES completion:nil];
        
    }else{
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Oops"
                                                        message:@"Looks like you don't have a Twitter account linked to this device."
                                                       delegate:self
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
    }
}
@end