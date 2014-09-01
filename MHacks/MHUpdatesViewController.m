//
//  UpdatesViewController.m
//  MHacks
//
//  Created by Spencer Yen on 2/6/14.
//
//  Edited and fixed by Christopher McGrath (Mr.Amazing) on 8/2/14
//  :D
//
//

#import "MHUpdatesViewController.h"
#import "MHLoginViewController.h"
#import "UIColor+MHacksColors.h"

#define kDetailsObjectKey @"details"
#define kTitleObjectKey @"title"

@interface MHUpdatesViewController ()
{
    NSMutableArray *arrayOfAnnouncements;
}

@property (nonatomic, strong) BOZPongRefreshControl *pongRefreshControl;

@end

@implementation MHUpdatesViewController

- (id)initWithCoder:(NSCoder *)aCoder
{
    self = [super initWithCoder:aCoder];
    if (self) {
        arrayOfAnnouncements = [NSMutableArray new];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [[UITabBar appearance] setTintColor:[UIColor datOrangeColor]];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(navigationBarDoubleTap:)];
    tap.numberOfTapsRequired = 3;
    [self.bar addGestureRecognizer:tap];
    [self canIHazParseDatas:^{}];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

-(void)viewDidAppear:(BOOL)animated{
    if(![[MHUserData sharedManager] isLoggedIn]){
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        MHLoginViewController *loginVC = (MHLoginViewController*)[storyboard instantiateViewControllerWithIdentifier:@"loginVC"];
        [self presentViewController:loginVC animated:NO completion:nil];
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

    MHUpdatesTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [[MHUpdatesTableViewCell alloc] init];
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
    MHUpdatesTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
    
    PFObject* announcement = [arrayOfAnnouncements objectAtIndex:indexPath.section];
    [cell setWithAnnouncement:announcement];
    
    return cell;
}

#pragma mark NavBar Buttons

- (IBAction)postToFacebookTapped:(id)sender {
    if ([SLComposeViewController isAvailableForServiceType:SLServiceTypeFacebook]){
        SLComposeViewController *composeController = [SLComposeViewController
                                                      composeViewControllerForServiceType:SLServiceTypeFacebook];
        
        [composeController setInitialText:@"Check out the MHacks hackathon!"];
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

- (void)navigationBarDoubleTap:(UIGestureRecognizer*)recognizer {
    [self.pongRefreshControl resetColors:self];
}
@end