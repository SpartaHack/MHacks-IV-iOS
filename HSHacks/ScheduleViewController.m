//
//  ScheduleViewController.m
//  HSHacks
//
//  Created by Spencer Yen on 2/17/14.
//  Copyright (c) 2014 hshacks.com. All rights reserved.
//

#import "ScheduleViewController.h"

@interface ScheduleViewController ()

@end

@implementation ScheduleViewController

@synthesize sections = _sections;
@synthesize sectionToDayMap = _sectionToDayMap;
@synthesize bodyArray;
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
    
    bodyArray = [[NSMutableArray alloc]init];
    PFQuery *queryBody = [PFQuery queryWithClassName:@"Event"];
    [queryBody selectKeys:@[@"description"]];
    NSArray *objects = [queryBody findObjects];
    for (int i = 0; i < objects.count;i++) {
        [bodyArray insertObject:[objects[i] objectForKey:@"description"] atIndex:0];
    }
    NSLog(@"bodyarray: %@", bodyArray);
    
    PFQuery *query = [PFQuery queryWithClassName:@"Event"];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            for(int i = 0; i < objects.count; i++){
                [objects[i] objectForKey:@"description"];
                
            }
        } else {
            // Log details of the failure
            NSLog(@"Error: %@ %@", error, [error userInfo]);
        }
    }];
    
	// Do any additional setup after loading the view.
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
        //Parse class name
        self.parseClassName = @"Event";
        
        //Default display
        self.textKey = @"name";
        
        self.pullToRefreshEnabled = NO;
        self.paginationEnabled = NO;
        self.objectsPerPage = 150;
        self.sections = [NSMutableDictionary dictionary];
        self.sectionToDayMap = [NSMutableDictionary dictionary];
        
    }
    return self;
}

- (PFQuery *)queryForTable {
    PFQuery *query = [PFQuery queryWithClassName:self.parseClassName];
    
    // If Pull To Refresh is enabled, query against the network by default.
    if (self.pullToRefreshEnabled) {
        query.cachePolicy = kPFCachePolicyNetworkOnly;
    }
    
    // If no objects are loaded in memory, we look to the cache first to fill the table
    // and then subsequently do a query against the network.
    if (self.objects.count == 0) {
        query.cachePolicy = kPFCachePolicyCacheThenNetwork;
    }
    for (PFObject *object in self.objects) {
        
        NSString *description = [object objectForKey:@"description"];
        if(![bodyArray containsObject:description]){
            [bodyArray insertObject:description atIndex:0];
        }
    }
    
    // Order by Day
    [query orderByAscending:@"time"];
    
    query.cachePolicy = kPFCachePolicyCacheThenNetwork;
    
    return query;
    
}

- (NSString *)dayForSection:(NSInteger)section {
    return [self.sectionToDayMap objectForKey:[NSNumber numberWithInt:section]];
}

- (void)objectsDidLoad:(NSError *)error {
    [super objectsDidLoad:error];
    
    // This method is called every time objects are loaded from Parse via the PFQuery
    
    [self.sections removeAllObjects];
    [self.sectionToDayMap removeAllObjects];
    
    NSInteger section = 0;
    NSInteger rowIndex = 0;
    for (PFObject *object in self.objects) {
        
        NSDate *time = [object objectForKey:@"time"];
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        dateFormatter.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US"];
        [dateFormatter setDateFormat:@"EEEE, MMMM dd"];
        NSString *day= [dateFormatter stringFromDate:time];
        NSLog(@"day: %@", day);
        
        NSMutableArray *objectsInSection = [self.sections objectForKey:day];
        if (!objectsInSection) {
            objectsInSection = [NSMutableArray array];
            
            // this is the first time we see this day- increment the section index
            [self.sectionToDayMap setObject:day forKey:[NSNumber numberWithInt:section++]];
        }
        
        [objectsInSection addObject:[NSNumber numberWithInt:rowIndex++]];
        [self.sections setObject:objectsInSection forKey:day];
    }
    [self.tableView reloadData];
}


- (PFObject *)objectAtIndexPath:(NSIndexPath *)indexPath {
    NSString *day= [self dayForSection:indexPath.section];
    
    NSArray *rowIndecesInSection = [self.sections objectForKey:day];
    NSNumber *rowIndex = [rowIndecesInSection objectAtIndex:indexPath.row];
    return [self.objects objectAtIndex:[rowIndex intValue]];
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.sections.allKeys.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSString *day= [self dayForSection:section];
    NSArray *rowIndecesInSection = [self.sections objectForKey:day];
    return rowIndecesInSection.count;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    NSString *day= [self dayForSection:section];
    return day;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 23.0;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //Get a reference to your string to base the cell size on.
    NSString *bodyString = [[self.objects objectAtIndex:indexPath.row] objectForKey:@"description"];
    NSLog(@"bodystring : %@", bodyString);
    //set the desired size of your textbox
    CGSize constraint = CGSizeMake(295, MAXFLOAT);
    //set your text attribute dictionary
    NSDictionary *attributes = [NSDictionary dictionaryWithObject:[UIFont systemFontOfSize:13.0] forKey:NSFontAttributeName];
    //get the size of the text box
    CGRect textsize = [bodyString boundingRectWithSize:constraint options:NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil];
    //calculate your size
    float textHeight = textsize.size.height + 10;
    NSLog(@"%f", textHeight + 30);
    return textHeight + 30 ;
}

#pragma mark - UITableViewDelegate


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath object:(PFObject *)object
{
    static NSString *simpleTableIdentifier = @"ScheduleCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
    }
    
    // Configure the cell
  
    UILabel *nameLabel = (UILabel*) [cell viewWithTag:100];
    nameLabel.text = [object objectForKey:@"name"];
    
    UILabel *detailsLabel = (UILabel*) [cell viewWithTag:104];
    NSString *detailsString =[object objectForKey:@"description"];
    
    CGSize constraint = CGSizeMake(295, MAXFLOAT);
    NSDictionary *attributes = [NSDictionary dictionaryWithObject:[UIFont systemFontOfSize:13.0] forKey:NSFontAttributeName];
    CGRect newFrame = [detailsString boundingRectWithSize:constraint options:NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil];
    detailsLabel.frame = CGRectMake(16,25,newFrame.size.width, newFrame.size.height);
    NSLog(@"frame height: %f", newFrame.size.height);
    NSLog(@"details string = %@", detailsString);
    detailsLabel.text = detailsString;
    [detailsLabel sizeToFit];
    
   UILabel *timeLabel = (UILabel*) [cell viewWithTag:101];
    NSDate *time = [object objectForKey:@"time"];
    NSLog(@"time: %@", time);
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    NSLocale *twelveHourLocale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"];
    dateFormatter.locale = twelveHourLocale;
    [dateFormatter setDateFormat:@"hh:mm a"];
    timeLabel.text = [dateFormatter stringFromDate:time];
    
    return cell;
}





@end
