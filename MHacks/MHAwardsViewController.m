//
//  AwardsViewController.m
//  HSHacks
//
//  Created by Spencer Yen on 2/17/14.
//  Copyright (c) 2014 hshacks.com. All rights reserved.
//

#import "MHAwardsViewController.h"
#import "AwardsTableViewCell.h"

@implementation MHAwardsViewController

@synthesize detailsArray, trueContentSize;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.tableView.separatorInset = UIEdgeInsetsZero;
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    self.tableView.userInteractionEnabled = YES;
    [self loadObjects];
}

- (id)initWithCoder:(NSCoder *)aCoder
{
    self = [super initWithCoder:aCoder];
    if (self) {
        // The className to query on
        self.parseClassName = @"Award";
        
        // The key of the PFObject to display in the label of the default cell style
        self.pullToRefreshEnabled = NO;
        self.paginationEnabled = NO;
    }
    return self;
}

- (PFQuery *)queryForTable
{
    PFQuery *query = [PFQuery queryWithClassName:self.parseClassName];
    query.cachePolicy = kPFCachePolicyCacheThenNetwork;
    [query includeKey:@"sponsor"];
    [query orderByAscending:@"ID"];
    
    return query;
}

- (void)objectsDidLoad:(NSError *)error {
    [super objectsDidLoad:error];
    [self.tableView reloadData];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath object:(PFObject *)object
{
    static NSString *simpleTableIdentifier = @"AwardsCell";
    
    AwardsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    if (cell == nil) {
        cell = [[AwardsTableViewCell alloc] init];
    }

    cell.titleLabel.text = object[@"title"];
    cell.prizeMoneyLabel.text = object[@"prize"];
    cell.detailLabel.text = object[@"details"];
    cell.companyLabel.text = object[@"sponsor"][@"title"];
    
    return cell;
}

@end
