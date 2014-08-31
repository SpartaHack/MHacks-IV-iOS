//
//  ScheduleViewController.m
//  HSHacks
//
//  Created by Spencer Yen on 2/17/14.
//  Copyright (c) 2014 hshacks.com. All rights reserved.
//

#import "MHScheduleViewController.h"

@implementation MHScheduleViewController

@synthesize sections = _sections;
@synthesize sectionToDayMap = _sectionToDayMap;
@synthesize bodyArray;

- (id)initWithCoder:(NSCoder *)aCoder
{
    self = [super initWithCoder:aCoder];
    if (self) {
        //Parse class name
        self.parseClassName = @"Event";
        
        //Default display
        self.textKey = @"title";
        
        self.pullToRefreshEnabled = NO;
        self.paginationEnabled = NO;
        self.sections = [NSMutableDictionary dictionary];
        self.sectionToDayMap = [NSMutableDictionary dictionary];
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.tableView.separatorInset = UIEdgeInsetsZero;
    self.tableView.userInteractionEnabled = YES;
    self.tableView.bounces = YES;
}

- (void)viewWillAppear:(BOOL)animated
{
    [self loadObjects];
}

- (PFQuery *)queryForTable {
    PFQuery *query = [PFQuery queryWithClassName:self.parseClassName];
    
    [query orderByAscending:@"time"];
    query.cachePolicy = kPFCachePolicyCacheThenNetwork;
    query.limit = 1000;
    
    return query;
}

- (NSString *)dayForSection:(NSInteger)section {
    return [self.sectionToDayMap objectForKey:[NSNumber numberWithInt:section]];
}

- (void)objectsDidLoad:(NSError *)error {
    [super objectsDidLoad:error];
    
    [self.sections removeAllObjects];
    [self.sectionToDayMap removeAllObjects];
    
    NSInteger section = 0;
    NSInteger rowIndex = 0;
    for (PFObject *object in self.objects) {
        NSDate *time = [object objectForKey:@"time"];
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        dateFormatter.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US"];
        [dateFormatter setDateFormat:@"EEEE, MMMM dd"];
        NSString *day = [dateFormatter stringFromDate:time];
        
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
    NSString *day = [self dayForSection:indexPath.section];
    
    NSArray *rowIndecesInSection = [self.sections objectForKey:day];
    NSNumber *rowIndex = [rowIndecesInSection objectAtIndex:indexPath.row];
    return [self.objects objectAtIndex:[rowIndex intValue]];
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.sections.allKeys.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSString *day = [self dayForSection:section];
    NSArray *rowIndecesInSection = [self.sections objectForKey:day];
    return rowIndecesInSection.count;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    NSString *day = [NSString stringWithFormat:@"   %@", [self dayForSection:section]];
    return day;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 23.0;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *bodyString = [[self.objects objectAtIndex:indexPath.row]objectForKey:@"description"];
    //set the desired size of your textbox
    CGSize constraint = CGSizeMake(295, MAXFLOAT);
    //set your text attribute dictionary
    NSDictionary *attributes = [NSDictionary dictionaryWithObject:[UIFont systemFontOfSize:13.0] forKey:NSFontAttributeName];
    //get the size of the text box
    CGRect textsize = [bodyString boundingRectWithSize:constraint options:NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil];
    //calculate your size
    float textHeight = textsize.size.height + 10;
    return textHeight + 40 ;
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
    nameLabel.text = [object objectForKey:@"title"];
    
    UILabel *detailsLabel = (UILabel*) [cell viewWithTag:104];
    NSString *detailsString =[object objectForKey:@"details"];
    
    CGSize constraint = CGSizeMake(295, MAXFLOAT);
    NSDictionary *attributes = [NSDictionary dictionaryWithObject:[UIFont systemFontOfSize:13.0] forKey:NSFontAttributeName];
    CGRect newFrame = [detailsString boundingRectWithSize:constraint options:NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil];
    detailsLabel.frame = CGRectMake(16,28,newFrame.size.width, newFrame.size.height);
 

    detailsLabel.text = detailsString;
    [detailsLabel sizeToFit];
   
    
   UILabel *timeLabel = (UILabel*) [cell viewWithTag:101];
    NSDate *time = [object objectForKey:@"time"];

    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setTimeZone:[NSTimeZone timeZoneWithName:@"UTC"]];
    [dateFormatter setDateFormat:@"h:mm a"];
    timeLabel.text = [dateFormatter stringFromDate:time];
    
    return cell;
}

@end
