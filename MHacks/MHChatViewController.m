//
//  ChatViewController.m
//  HSHacks
//
//  Created by Spencer Yen on 2/6/14.
//  Copyright (c) 2014 hshacks.com. All rights reserved.
//

#import "MHChatViewController.h"
#import "MHChatMessageTableViewCell.h"
#import "MHUserData.h"
#import <QuartzCore/QuartzCore.h>
#import "DAKeyboardControl.h"

@implementation MHChatViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.chatTableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
    self.chatTextField.enablesReturnKeyAutomatically = YES;
    
    MHUserData *userData = [MHUserData sharedManager];
    self.name = userData.userName;
    self.photoURL = userData.userPhoto;
    
    // Initialize array that will store chat messages.
    self.chatMessages = [[NSMutableArray alloc] init];
    
    // Initialize the root of our Firebase namespace.
    self.firebase = [[Firebase alloc] initWithUrl:self.firechatUrl];
    
    self.hasInitialDataBeenLoaded = NO;
    
    self.chatMessagesQuery = [self.firebase queryLimitedToNumberOfChildren:50];
    [self.chatMessagesQuery observeEventType:FEventTypeChildAdded withBlock:^(FDataSnapshot *snapshot) {
        // Add the chat message to the array.
        [self.chatMessages addObject:snapshot.value];
        
        // Reload the table view so the new message will show up.
        if (self.hasInitialDataBeenLoaded) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.chatTableView reloadData];
                [self.chatTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:self.chatMessages.count-1 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:NO];
            });
        }
    }];
    
    [self.chatMessagesQuery observeSingleEventOfType:FEventTypeValue withBlock:^(FDataSnapshot *snapshot) {
        self.hasInitialDataBeenLoaded = YES;
        
        [self.chatTableView reloadData];
        [self.chatTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:self.chatMessages.count-1 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:NO];
    }];
    
    [self registerViewToMoveWithKeyboard:self.chatTableView];
    [self registerViewToMoveWithKeyboard:self.chatTextField];
}

#pragma mark - Text field handling

- (BOOL)textFieldShouldReturn:(UITextField*)textField
{
    [self dismissKeyboard];
    
    if(self.name && self.photoURL) {
        NSString* message = [textField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        
        if (message.length > 0) {
            [[self.firebase childByAutoId] setValue:@{ @"user" : self.name,
                                                       @"message": message,
                                                       @"image" : self.photoURL }];
        }
    }
    
    [textField setText:@""];
    
    return NO;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView*)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView*)table numberOfRowsInSection:(NSInteger)section
{
    return [self.chatMessages count];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static MHChatMessageTableViewCell *cell = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        cell = [self.chatTableView dequeueReusableCellWithIdentifier:@"ChatCell"];
    });
    
    NSDictionary* chatMessage = [self.chatMessages objectAtIndex:indexPath.row];
    [cell setWithChatMessage:chatMessage atIndex:indexPath.row];
    
    [cell setNeedsLayout];
    [cell layoutIfNeeded];
    
    CGSize size = [cell.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize];
    return size.height;
}

- (UITableViewCell*)tableView:(UITableView*)table cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MHChatMessageTableViewCell *cell = [table dequeueReusableCellWithIdentifier:[MHChatMessageTableViewCell cellIdentifier]];
    
    NSDictionary* chatMessage = [self.chatMessages objectAtIndex:indexPath.row];
    [cell setWithChatMessage:chatMessage atIndex:indexPath.row];
    
    return cell;
}

@end
