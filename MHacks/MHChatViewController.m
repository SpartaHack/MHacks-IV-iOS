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

@implementation MHChatViewController

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];

    self.chatTextField.userInteractionEnabled = NO;
    
    self.chatTableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
    
    //Remove separator
    self.chatTableView.separatorColor = [UIColor clearColor];
    
    self.chatTextField.enablesReturnKeyAutomatically = YES;
    
    MHUserData *userData = [MHUserData sharedManager];
    
    // Initialize array that will store chat messages.
    self.chatMessages = [[NSMutableArray alloc] init];
    
    // Initialize the root of our Firebase namespace.
    self.firebase = [[Firebase alloc] initWithUrl:self.firechatUrl];
    
    //Store name and photoURL in UserDefaults
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    userData.userName = [defaults objectForKey:@"name"];
    userData.userPhoto = [defaults objectForKey:@"photo"];
    
    self.name = userData.userName;
    self.photoURL = userData.userPhoto;
    
    [self.firebase observeEventType:FEventTypeChildAdded withBlock:^(FDataSnapshot *snapshot) {
        // Add the chat message to the array.
        // TODO: take this out, we need to hook chat up to the different chat rooms and such
        if (![snapshot.name isEqualToString:@"chat"]) {
            [self.chatMessages addObject:snapshot.value];
            
            // Reload the table view so the new message will show up.
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.chatTableView reloadData];
                
                self.chatTextField.userInteractionEnabled = TRUE;
                [self.chatTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:self.chatMessages.count-1 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:NO];
            });
        }
    }];
}

#pragma mark - Text field handling

- (BOOL)textFieldShouldReturn:(UITextField*)textField
{
    [textField resignFirstResponder];
    
    if(self.chatMessages.count > 0){
        if(self.name && self.photoURL){
            NSString* message = [textField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
            
            if (message.length > 0) {
                [[self.firebase childByAutoId] setValue:@{ @"user" : self.name,
                                                           @"message": message,
                                                           @"image" : self.photoURL }];
            }
        }
        
        [textField setText:@""];
    }
    
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

#pragma mark - Keyboard handling

// Subscribe to keyboard show/hide notifications.
- (void)viewWillAppear:(BOOL)animated
{
    [[NSNotificationCenter defaultCenter]
     addObserver:self selector:@selector(keyboardWillShow:)
     name:UIKeyboardWillShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter]
     addObserver:self selector:@selector(keyboardWillHide:)
     name:UIKeyboardWillHideNotification object:nil];
}

// Unsubscribe from keyboard show/hide notifications.
- (void)viewWillDisappear:(BOOL)animated
{
    [[NSNotificationCenter defaultCenter]
     removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter]
     removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}

// Setup keyboard handlers to slide the view containing the table view and
// text field upwards when the keyboard shows, and downwards when it hides.
- (void)keyboardWillShow:(NSNotification*)notification
{
    
    CGRect chatTextFieldFrame = CGRectMake(self.chatTextField.frame.origin.x,self.chatTextField.frame.origin.y-170,self.chatTextField.frame.size.width,self.chatTextField.frame.size.height);
    [UIView animateWithDuration:0.3 animations:^{ self.chatTextField.frame = chatTextFieldFrame;}];
    
    CGRect chatTableViewFrame = CGRectMake(0,65,320,self.chatTableView.frame.size.height-170);
    [UIView animateWithDuration:0.0 animations:^{ self.chatTableView.frame = chatTableViewFrame;}];
    
    if([NSIndexPath indexPathForRow:self.chatMessages.count-1 inSection:0]){
        [self.chatTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:self.chatMessages.count-1 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:NO];
    }
}

- (void)keyboardWillHide:(NSNotification*)notification
{
    CGRect chatTextFieldFrame = CGRectMake(self.chatTextField.frame.origin.x,self.chatTextField.frame.origin.y+170,self.chatTextField.frame.size.width,self.chatTextField.frame.size.height);
    [UIView animateWithDuration:0.3 animations:^{ self.chatTextField.frame = chatTextFieldFrame;}];
    
    CGRect chatTableViewFrame = CGRectMake(0,65,320,self.chatTableView.frame.size.height+170);
    [UIView animateWithDuration:0.0 animations:^{ self.chatTableView.frame = chatTableViewFrame;}];
}

@end
