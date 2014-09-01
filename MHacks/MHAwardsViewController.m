//
//  AwardsViewController.m
//  HSHacks
//
//  Created by Spencer Yen on 2/17/14.
//  Copyright (c) 2014 hshacks.com. All rights reserved.
//

#import "MHAwardsViewController.h"
#import "MHAwardsTableViewCell.h"

@interface MHAwardsViewController ()
{
    NSMutableArray *arrayOfAwards;
}
@end

@implementation MHAwardsViewController

- (id)initWithCoder:(NSCoder *)aCoder
{
    self = [super initWithCoder:aCoder];
    if (self) {
        arrayOfAwards = [NSMutableArray new];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self canIHazParseDatas:^{}];
}

- (void)canIHazParseDatas:(void(^)())block
{
    PFQuery *query = [PFQuery queryWithClassName:@"Award"];
    query.cachePolicy = kPFCachePolicyCacheThenNetwork;
    [query includeKey:@"sponsor"];
    [query orderByDescending:@"value"];
    query.limit = 1000;
    
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            [arrayOfAwards removeAllObjects];
            [arrayOfAwards addObjectsFromArray:objects];
        } else {
            UIAlertView *alert = [[UIAlertView alloc]
                                  initWithTitle:@"D'oh!"
                                  message:@"Couldn't get the awards!"
                                  delegate:nil
                                  cancelButtonTitle:@"Ugh"
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

# pragma mark Table view funtimes

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [arrayOfAwards count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    PFObject* award = [arrayOfAwards objectAtIndex:section];
    return award[@"title"];
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"AwardCell";
    
    MHAwardsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [[MHAwardsTableViewCell alloc] init];
    }
    
    PFObject* award = [arrayOfAwards objectAtIndex:indexPath.section];
    [cell setWithAward:award];
    
    [cell setNeedsLayout];
    [cell layoutIfNeeded];
    
    CGSize size = [cell.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize];
    return size.height;
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewAutomaticDimension;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"AwardCell";
    
    MHAwardsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [[MHAwardsTableViewCell alloc] init];
    }
    
    PFObject* award = [arrayOfAwards objectAtIndex:indexPath.section];
    [cell setWithAward:award];
    
    return cell;
}

@end
