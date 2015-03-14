//
//  UpdatesViewController.m
//  Sacks
//
//  Created by Spencer Yen on 2/6/14.
//
//  Edited and fixed by Christopher McGrath (Mr.Amazing) on 8/2/14
//  :D
//
//

#import "SUpdatesViewController.h"
#import "SLoginViewController.h"
#import "UIColor+SpartaHackColors.h"

#define kDetailsObjectKey @"details"
#define kTitleObjectKey @"title"

@interface SUpdatesViewController ()
{
    NSMutableArray *arrayOfAnnouncements;
}

@property (nonatomic, strong) BOZPongRefreshControl *pongRefreshControl;

@end

@implementation SUpdatesViewController

- (id)initWithCoder:(NSCoder *)aCoder
{
    self = [super initWithCoder:aCoder];
    if (self) {
        arrayOfAnnouncements = [NSMutableArray new];
        
        //define some colors
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
//    [[UITabBar appearance] setTintColor:[UIColor colorWithWhite:0.10f alpha:1.0f]];
//    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(navigationBarDoubleTap:)];
//    tap.numberOfTapsRequired = 3;
//    [self.bar addGestureRecognizer:tap];

    [[UINavigationBar appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName: [UIColor whiteColor],
                                                           NSFontAttributeName: [UIFont fontWithName:@"phantom-light" size:28]}];

}

- (void)viewDidAppear:(BOOL)animated{

    if(![[SUserData sharedManager] isLoggedIn]){
        [self performSegueWithIdentifier:@"login" sender:nil];
    }else{
        [self canIHazParseDatas:^{}];
    }
}

- (void)canIHazParseDatas:(void(^)())block
{
    //Step 2 download all da data againz!!!!
    PFQuery *query = [PFQuery queryWithClassName:@"Announcement"];
    [query orderByDescending:@"createdAt"];
    [query includeKey:@"poster"];
    query.limit = 1000;
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            [arrayOfAnnouncements removeAllObjects];
            
            NSMutableArray* pinnedAnnouncements = [[NSMutableArray alloc] init];
            NSMutableArray* unpinnedAnnouncements = [[NSMutableArray alloc] init];
            
            for (PFObject* announcement in objects) {
                if ([announcement[@"pinned"] boolValue]) {
                    [pinnedAnnouncements addObject:announcement];
                } else {
                    [unpinnedAnnouncements addObject:announcement];
                }
            }
            
            [arrayOfAnnouncements addObjectsFromArray:pinnedAnnouncements];
            [arrayOfAnnouncements addObjectsFromArray:unpinnedAnnouncements];
        } else {
            UIAlertView *alert = [[UIAlertView alloc]
                                  initWithTitle:@"Whoops"
                                  message:@"Couldn't get the latest news!"
                                  delegate:nil
                                  cancelButtonTitle:@"Fine"
                                  otherButtonTitles:nil];
            [alert show];
        }
        //Step 4 tell the table view to redraw everything like the good little table it better be...... :P
        [self.tableView reloadData];
        block(nil,nil);
        //NSLog(@"Heyyyyy");
    }];
}

#pragma mark PONG PONG PONG

- (void)viewDidLayoutSubviews
{
    self.pongRefreshControl = [BOZPongRefreshControl attachToTableView:self.tableView
                                                     withRefreshTarget:self
                                                      andRefreshAction:@selector(refreshTriggered)];
    self.pongRefreshControl.backgroundColor = [UIColor p2Color];
    self.pongRefreshControl.foregroundColor = [UIColor p3Color];
    
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

#pragma mark Table View Related Stuffs

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [arrayOfAnnouncements count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    PFObject* announcement = [arrayOfAnnouncements objectAtIndex:section];
    return announcement[@"poster"][@"title"];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"UpdateCell";

    SUpdatesTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [[SUpdatesTableViewCell alloc] init];
    }

    PFObject* announcement = [arrayOfAnnouncements objectAtIndex:indexPath.section];
    [cell setWithAnnouncement:announcement];
    
    [cell setNeedsUpdateConstraints];
    [cell updateConstraintsIfNeeded];
    
    cell.bounds = CGRectMake(0.0f, 0.0f, CGRectGetWidth(tableView.bounds), CGRectGetHeight(cell.bounds));
    
    [cell setNeedsLayout];
    [cell layoutIfNeeded];
    
    CGFloat height = [cell.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize].height;
    
    height += 1.0f;
    
    return height;
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewAutomaticDimension;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"UpdateCell";
    SUpdatesTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
    PFObject* announcement = [arrayOfAnnouncements objectAtIndex:indexPath.section];
    [cell setWithAnnouncement:announcement];
    
    return cell;
}

#pragma mark NavBar Buttons

- (IBAction)postToFacebookTapped:(id)sender {
    if ([SLComposeViewController isAvailableForServiceType:SLServiceTypeFacebook]){
        SLComposeViewController *composeController = [SLComposeViewController
                                                      composeViewControllerForServiceType:SLServiceTypeFacebook];
        
        [composeController setInitialText:@"Check out SpartaHack hackathon!"];
        //Post actual selfie?
        //[composeController addImage:postImage.image];
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
        NSString *message = [NSString stringWithFormat:@"Check out the @spartahack hackathon!"];
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

- (UIStatusBarStyle) preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

- (void)navigationBarDoubleTap:(UIGestureRecognizer*)recognizer {
    [self.pongRefreshControl resetColors:self];
}
@end