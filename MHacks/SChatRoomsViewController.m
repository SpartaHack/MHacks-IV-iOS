//
//  SChatRoomsViewController.m
//  Sacks
//
//  Created by Ben Oztalay on 8/21/14.
//  Copyright (c) 2014 hshacks.com. All rights reserved.
//

#import "SChatRoomsViewController.h"
#import "SChatViewController.h"
#import "SUserData.h"
#import "SLoginViewController.h"
#import "SChatRoomTableViewCell.h"

#define kFirechatMessagesBase @"https://Sacks-f2014.firebaseio.com/chat/messages/"
#define kFirechatRooms @"https://Sacks-f2014.firebaseio.com/chat/rooms/"

@implementation SChatRoomsViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.roomsTableView.hidden = YES;
        
    // Initialize array that will store chat messages.
    self.chatRooms = [[NSMutableArray alloc] init];
    
    // Initialize the root of our Firebase namespace.
    self.firebase = [[Firebase alloc] initWithUrl:kFirechatRooms];
    self.hasInitialDataBeenLoaded = NO;
    
    [self.firebase observeEventType:FEventTypeChildAdded withBlock:^(FDataSnapshot *snapshot) {
        // Add the chat room to the array
        [self.chatRooms addObject:snapshot.value];
        
        // Reload the table view so the new message will show up.
        if (self.hasInitialDataBeenLoaded) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.roomsTableView reloadData];
                [self.roomsTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:self.chatRooms.count-1 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:NO];
            });
        }
    }];
    
    [self.firebase observeSingleEventOfType:FEventTypeValue withBlock:^(FDataSnapshot *snapshot) {
        self.hasInitialDataBeenLoaded = YES;
        self.roomsTableView.hidden = NO;
        
        [self.roomsTableView reloadData];
        [self.roomsTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:self.chatRooms.count-1 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:NO];
    }];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    NSIndexPath *indexPath = self.roomsTableView.indexPathForSelectedRow;
    if (indexPath) {
        [self.roomsTableView deselectRowAtIndexPath:indexPath animated:YES];
    }
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView*)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView*)table numberOfRowsInSection:(NSInteger)section
{
    return [self.chatRooms count];
}

- (UITableViewCell*)tableView:(UITableView*)table cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"RoomCell";
    SChatRoomTableViewCell *cell = [table dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[SChatRoomTableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
    }
    
    NSDictionary* chatRoom = [self.chatRooms objectAtIndex:indexPath.row];
    [cell setWithChatRoom:chatRoom];
    
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary* chatRoom = [self.chatRooms objectAtIndex:indexPath.row];
    self.chatRoomToEnter = chatRoom[@"title"];
    
    [self performSegueWithIdentifier:@"ChatRoomsToChat" sender:self];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"ChatRoomsToChat"]) {
        ((SChatViewController*)segue.destinationViewController).firechatUrl = [[NSURL URLWithString:self.chatRoomToEnter relativeToURL:[NSURL URLWithString:kFirechatMessagesBase]] absoluteString];
        ((SChatViewController*)segue.destinationViewController).navigationItem.title = self.chatRoomToEnter;
    }
}

#pragma mark - Logging out

- (IBAction)logoutPressed:(id)sender {
    UIAlertView *alert = [[UIAlertView alloc]
                          initWithTitle:@"For Realsies?"
                          message:@"Do you really want to log out?"
                          delegate:self
                          cancelButtonTitle:@"Nah"
                          otherButtonTitles:@"Yah", nil];
    [alert show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
        SUserData *userData = [SUserData sharedManager];
        userData.userName = nil;
        userData.userPhoto = nil;
        
        [PFUser logOut];
        
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        SLoginViewController *loginViewController = [storyboard instantiateViewControllerWithIdentifier:@"loginVC"];
        
        loginViewController.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
        [self presentViewController:loginViewController animated:YES completion:nil];
    }
}

@end
