//
//  UpdatesViewController.m
//  HSHacks
//
//  Created by Spencer Yen on 2/6/14.
//  Copyright (c) 2014 hshacks.com. All rights reserved.
//

#import "MHUpdatesViewController.h"
#import "MHLoginViewController.h"


@interface MHUpdatesViewController ()

@property (nonatomic, strong) BOZPongRefreshControl *pongRefreshControl;

@end

@implementation MHUpdatesViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
		self.pullToRefreshEnabled = NO;
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.tableView.separatorInset = UIEdgeInsetsZero;

    
}
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
	[super scrollViewDidScroll:scrollView];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    [self.pongRefreshControl scrollViewDidEndDragging];
	[super scrollViewDidEndDragging:scrollView willDecelerate:decelerate];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
   
        [self loadObjects];
    
}
-(void)viewDidAppear:(BOOL)animated{
    if(![self isLoggedIn]){

        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        MHLoginViewController *loginVC = (MHLoginViewController*)[storyboard instantiateViewControllerWithIdentifier:@"loginVC"];
        [self presentViewController:loginVC animated:NO completion:nil];
        
    }

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    
}


-(BOOL)isLoggedIn{
 
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    MHUserData *userData = [MHUserData sharedManager];

    userData.userName = [defaults objectForKey:@"name"];
    userData.userPhoto = [defaults objectForKey:@"photo"];
    if(userData.userPhoto == NULL || userData.userName == NULL){
        return NO;
    }
    if([[defaults objectForKey:@"loggedIn"] isEqualToString:@"YES"]){

        return YES;
    }
    else{
        return NO;
    }
}

- (id)initWithCoder:(NSCoder *)aCoder
{
    self = [super initWithCoder:aCoder];
    if (self) {
        // The className to query on
        self.parseClassName = @"Announcement";
        
        // The key of the PFObject to display in the label of the default cell style
        self.textKey = @"createdAt";
        self.pullToRefreshEnabled = NO;
        self.paginationEnabled = NO;
    
    
    }
    return self;
}

- (PFQuery *)queryForTable
{
    PFQuery *query = [PFQuery queryWithClassName:self.parseClassName];
    query.cachePolicy = kPFCachePolicyCacheThenNetwork;
    
    [query orderByDescending:@"createdAt"];
    
   
    
    return query;
}


- (void)objectsDidLoad:(NSError *)error {
    [super objectsDidLoad:error];
    

    [self.tableView reloadData];
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //Get a reference to your string to base the cell size on.
    NSString *bodyString;

    bodyString = [[self.objects objectAtIndex:indexPath.row]objectForKey:@"details"];

    //set the desired size of your textbox
    CGSize constraint = CGSizeMake(298, MAXFLOAT);

    NSDictionary *attributes = [NSDictionary dictionaryWithObject:[UIFont systemFontOfSize:13.0] forKey:NSFontAttributeName];
    CGRect textsize = [bodyString boundingRectWithSize:constraint options:NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil];
    //calculate your size
    float textHeight = textsize.size.height + 10;


    return textHeight + 78;
	
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath object:(PFObject *)object
{
	
    
    static NSString *simpleTableIdentifier = @"UpdateCell";
	
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
    }
    
    
    UILabel *titleLabel = (UILabel*) [cell viewWithTag:101];
    titleLabel.text = [object objectForKey:@"title"];
    
    //Set bodytext, adjust size of label
    UILabel *bodyText = (UILabel*) [cell viewWithTag:104];
    
    NSString *bodyString =[object objectForKey:@"details"];
    
    CGSize constraint = CGSizeMake(298, MAXFLOAT);
    NSDictionary *attributes = [NSDictionary dictionaryWithObject:[UIFont systemFontOfSize:13.0] forKey:NSFontAttributeName];
    CGRect newFrame = [bodyString boundingRectWithSize:constraint options:NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil];
    bodyText.frame = CGRectMake(10,79,newFrame.size.width, newFrame.size.height);
    bodyText.text = bodyString;
    [bodyText sizeToFit];
    
    //Set date label
    UILabel *timeLabel = (UILabel*) [cell viewWithTag:103];
    NSDate *time = object.createdAt;
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"M/dd hh:mm a"];
    timeLabel.text = [dateFormatter stringFromDate:time];
    
    
    return cell;
}


#pragma mark Refresh View

- (void)refreshTriggered
{
    //Go and load some data
	
    //Finshed loading the data, reset the refresh control
	
	double delayInSeconds = 2.0;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        NSLog(@"DONE");
		
        // When done requesting/reloading/processing invoke endRefreshing, to close the control
		[self loadObjects];
		[self.pongRefreshControl finishedLoading];
        //
		[self.refreshControl endRefreshing];
    });
	
}



@end