//
//  ScheduleViewController.m
//  HSHacks
//
//  Created by Spencer Yen on 2/17/14.
//  Copyright (c) 2014 hshacks.com. All rights reserved.
//

#import "MHScheduleViewController.h"
#import "MHScheduleTableViewCell.h"

@implementation MHScheduleViewController

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
    self.tableView.separatorInset = UIEdgeInsetsZero;
    self.tableView.userInteractionEnabled = YES;
    self.tableView.bounces = YES;

    PFQuery *query = [PFQuery queryWithClassName:@"Event"];
    [query orderByAscending:@"time"];
    [query includeKey:@"host"];
    query.limit = 1000;
    
    [query findObjectsInBackgroundWithBlock:^(NSArray* objects, NSError* error) {
        if (!error) {
            [self.days removeAllObjects];
            [self.eventsByDay removeAllObjects];
            
            NSDateFormatter* dayFormatter = [[NSDateFormatter alloc] init];
            dayFormatter.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US"];
            [dayFormatter setDateFormat:@"EEEE, MMMM dd"];
            
            for (PFObject *event in objects) {
                NSDate *time = [event objectForKey:@"time"];
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
    }];
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
    return [NSString stringWithFormat:@"   %@", [self.days objectAtIndex:section]];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 23.0;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"ScheduleCell";
    
    MHScheduleTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [[MHScheduleTableViewCell alloc] init];
    }
    
    NSString *day = [self.days objectAtIndex:indexPath.section];
    NSArray *eventsInDay = [self.eventsByDay objectForKey:day];
    PFObject* event = [eventsInDay objectAtIndex:indexPath.row];
    [cell setWithEvent:event];
    
    [cell setNeedsLayout];
    [cell layoutIfNeeded];
    
    CGSize size = [cell.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize];
    return size.height;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"ScheduleCell";
    
    MHScheduleTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [[MHScheduleTableViewCell alloc] init];
    }
    
    NSString *day = [self.days objectAtIndex:indexPath.section];
    NSArray *eventsInDay = [self.eventsByDay objectForKey:day];
    PFObject* event = [eventsInDay objectAtIndex:indexPath.row];
    [cell setWithEvent:event];
    
    return cell;
}

@end
