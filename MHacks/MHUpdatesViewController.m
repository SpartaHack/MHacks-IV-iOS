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

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)canIHazParseDatas:(void(^)())block
{
    //Step 1 remove old datas
    [arrayOfAnnouncements removeAllObjects];
    //Step 2 download all da data againz!!!!
    PFQuery *query = [PFQuery queryWithClassName:@"Announcement"];
    [query orderByDescending:@"pinned"];
    [query includeKey:@"poster"];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            [arrayOfAnnouncements addObjectsFromArray:objects];
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
	[super viewDidLayoutSubviews];
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

    UpdatesTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [[UpdatesTableViewCell alloc] init];
    }

    cell.titleLabel.text = [[arrayOfAnnouncements objectAtIndex:indexPath.section] objectForKey:kTitleObjectKey];
    cell.detailLabel.text = [[arrayOfAnnouncements objectAtIndex:indexPath.section] objectForKey:kDetailsObjectKey];
    
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
    UpdatesTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
    
    PFObject* announcement = [arrayOfAnnouncements objectAtIndex:indexPath.section];
    cell.titleLabel.text = [announcement objectForKey:kTitleObjectKey];
    cell.detailLabel.text = [announcement objectForKey:kDetailsObjectKey];
    
    if ([announcement[@"pinned"] boolValue]) {
        cell.pinnedLabel.hidden = NO;
    } else {
        cell.pinnedLabel.hidden = YES;
    }
    
    [cell setNeedsUpdateConstraints];
    [cell updateConstraintsIfNeeded];
    return cell;
}

#pragma mark Refresh View

- (void)refreshTriggered
{
    //Go and load some data
    [self canIHazParseDatas:^{
        [self.pongRefreshControl finishedLoading];
    }];

}

#pragma mark NavBar Buttons

- (IBAction)postToFacebookTapped:(id)sender {
    if ([SLComposeViewController isAvailableForServiceType:SLServiceTypeFacebook]){
        SLComposeViewController *composeController = [SLComposeViewController
                                                      composeViewControllerForServiceType:SLServiceTypeFacebook];
        
        [composeController setInitialText:@"Check out the Mhacks hackathon!"];
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