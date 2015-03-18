//
//  ScheduleViewController.m
//  HSHacks
//
//  Created by Spencer Yen on 2/17/14.
//  Copyright (c) 2014 hshacks.com. All rights reserved.
//

#import "SScheduleViewController.h"
#import "SScheduleTableViewCell.h"

@implementation SScheduleViewController

- (id)initWithCoder:(NSCoder *)aCoder
{
    self = [super initWithCoder:aCoder];
    if (self) {
        self.days = [[NSMutableArray alloc] init];
        self.eventsByDay = [[NSMutableDictionary alloc] init];
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
    PFQuery *query = [PFQuery queryWithClassName:@"Event"];
    [query includeKey:@"Sponsor"];
    [query orderByAscending:@"Time"];
    query.limit = 1000;
    
    [query findObjectsInBackgroundWithBlock:^(NSArray* objects, NSError* error) {
        if (!error) {
            [self.days removeAllObjects];
            [self.eventsByDay removeAllObjects];
            
            NSDateFormatter* dayFormatter = [[NSDateFormatter alloc] init];
            dayFormatter.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US"];
            [dayFormatter setDateFormat:@"EEEE, MMMM dd"];
            
            for (PFObject *event in objects) {
                NSDate *time = [event objectForKey:@"Time"];
                NSString *day = [dayFormatter stringFromDate:time];
                
                NSMutableArray *eventsInDay = [self.eventsByDay objectForKey:day];
                if (eventsInDay == nil) {
                    eventsInDay = [NSMutableArray array];
                    [self.eventsByDay setObject:eventsInDay forKey:day];
                    [self.days addObject:day];
                }
                
                [eventsInDay addObject:event];
            }
        } else {
            UIAlertView *alert = [[UIAlertView alloc]
                                  initWithTitle:@"Uhhh"
                                  message:@"Couldn't get the events!"
                                  delegate:nil
                                  cancelButtonTitle:@"Kidding me?"
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

- (void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section
{
    // Background color
    view.tintColor = [UIColor p3Color];
    
    // Text Color
    UITableViewHeaderFooterView *header = (UITableViewHeaderFooterView *)view;
    [header.textLabel setTextColor:[UIColor p2Color]];
    
    // Another way to set the background color
    // Note: does not preserve gradient effect of original header
    // header.contentView.backgroundColor = [UIColor blackColor];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [self.pongRefreshControl scrollViewDidScroll];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    [self.pongRefreshControl scrollViewDidEndDragging];
}

#pragma mark - Tables on tables

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.days.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSArray* eventsInDay = [self.eventsByDay objectForKey:[self.days objectAtIndex:section]];
    return eventsInDay.count;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return [self.days objectAtIndex:section];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 23.0;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"ScheduleCell";
    
    SScheduleTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [[SScheduleTableViewCell alloc] init];
    }
    
    NSString *day = [self.days objectAtIndex:indexPath.section];
    NSArray *eventsInDay = [self.eventsByDay objectForKey:day];
    PFObject* event = [eventsInDay objectAtIndex:indexPath.row];
    [cell setWithEvent:event];
    
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
    static NSString *cellIdentifier = @"ScheduleCell";
    
    SScheduleTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [[SScheduleTableViewCell alloc] init];
    }
    
    NSString *day = [self.days objectAtIndex:indexPath.section];
    NSArray *eventsInDay = [self.eventsByDay objectForKey:day];
    PFObject* event = [eventsInDay objectAtIndex:indexPath.row];
    [cell setWithEvent:event];
    
    return cell;
}

@end
