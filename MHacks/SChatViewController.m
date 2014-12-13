//
//  ChatViewController.m
//  HSHacks
//
//  Created by Spencer Yen on 2/6/14.
//  Copyright (c) 2014 hshacks.com. All rights reserved.
//

#import "SChatViewController.h"
#import "SChatMessageTableViewCell.h"
#import "SUserData.h"
#import <QuartzCore/QuartzCore.h>

@implementation SChatViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.chatTableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
    self.chatTextField.enablesReturnKeyAutomatically = YES;
    
    SUserData *userData = [SUserData sharedManager];
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
}

#pragma mark - Text field handling

- (BOOL)textFieldShouldReturn:(UITextField*)textField
{
    [textField resignFirstResponder];
    
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
    static SChatMessageTableViewCell *cell = nil;
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
    SChatMessageTableViewCell *cell = [table dequeueReusableCellWithIdentifier:[SChatMessageTableViewCell cellIdentifier]];
    
    NSDictionary* chatMessage = [self.chatMessages objectAtIndex:indexPath.row];
    [cell setWithChatMessage:chatMessage atIndex:indexPath.row];
    
    return cell;
}

#pragma mark - Keyboard. Friggin keyboards.

#pragma mark - Keyboard handling

- (void)viewWillAppear:(BOOL)animated
{
    [[NSNotificationCenter defaultCenter]
     addObserver:self selector:@selector(keyboardWillShow:)
     name:UIKeyboardWillShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter]
     addObserver:self selector:@selector(keyboardWillHide:)
     name:UIKeyboardWillHideNotification object:nil];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [[NSNotificationCenter defaultCenter]
     removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter]
     removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}

- (void)keyboardWillShow:(NSNotification*)notification
{
    [self moveView:[notification userInfo] up:YES];
}

- (void)keyboardWillHide:(NSNotification*)notification
{
    [self moveView:[notification userInfo] up:NO];
}

- (void)moveView:(NSDictionary*)userInfo up:(BOOL)up
{
    CGRect keyboardEndFrame;
    [[userInfo objectForKey:UIKeyboardFrameEndUserInfoKey]
     getValue:&keyboardEndFrame];
    
    UIViewAnimationCurve animationCurve;
    [[userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey]
     getValue:&animationCurve];
    
    NSTimeInterval animationDuration;
    [[userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey]
     getValue:&animationDuration];
    
    // Get the correct keyboard size to we slide the right amount.
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:animationDuration];
    [UIView setAnimationCurve:animationCurve];
    
    CGRect keyboardFrame = [self.view convertRect:keyboardEndFrame toView:nil];
    CGFloat tabBarHeight = self.tabBarController.tabBar.frame.size.height;
    int y = (keyboardFrame.size.height - tabBarHeight) * (up ? -1 : 1);
    self.chatTableView.frame = CGRectOffset(self.chatTableView.frame, 0, y);
    self.chatTextField.frame = CGRectOffset(self.chatTextField.frame, 0, y);
    
    [UIView commitAnimations];
}

@end
