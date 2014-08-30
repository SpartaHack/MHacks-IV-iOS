//
//  AwardsViewController.m
//  HSHacks
//
//  Created by Spencer Yen on 2/17/14.
//  Copyright (c) 2014 hshacks.com. All rights reserved.
//

#import "MHAwardsViewController.h"
#import "AwardsTableViewCell.h"

@interface MHAwardsViewController ()

@end

@implementation MHAwardsViewController
@synthesize detailsArray, trueContentSize;
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
    self.tableView.separatorInset = UIEdgeInsetsZero;
    
	// Do any additional setup after loading the view.
}
- (void)viewWillAppear:(BOOL)animated
{
      self.tableView.userInteractionEnabled = YES;
        [super viewDidAppear:animated];

    [self loadObjects];
}

-(void)viewDidAppear:(BOOL)animated{
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (id)initWithCoder:(NSCoder *)aCoder
{
    self = [super initWithCoder:aCoder];
    if (self) {
        // The className to query on
        self.parseClassName = @"Award";
        
        // The key of the PFObject to display in the label of the default cell style
        self.textKey = @"title";
        self.pullToRefreshEnabled = NO;
        self.paginationEnabled = NO;
      
        
    }
    return self;
}

- (PFQuery *)queryForTable
{
    PFQuery *query = [PFQuery queryWithClassName:self.parseClassName];
    query.cachePolicy = kPFCachePolicyCacheThenNetwork;
    
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

    //Set Prize label
    cell.prizeMoneyLabel.text = [object objectForKey:@"prize"];
    cell.detailLabel.text =[object objectForKey:@"details"];
    PFObject *spon = object[@"sponsor"];
//    NSLog(@"YO %@",spon);
//    cell.companyLabel.text = [[object objectForKey:@"sponsor"] objectForKey:@"title"];
    
    return cell;
}



@end
