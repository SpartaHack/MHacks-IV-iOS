//
//  MHChatRoomsViewController.m
//  MHacks
//
//  Created by Ben Oztalay on 8/21/14.
//  Copyright (c) 2014 hshacks.com. All rights reserved.
//

#import "MHChatRoomsViewController.h"
#import "MHChatViewController.h"

#define kFirechatMessagesBase @"https://mhacks-f2014.firebaseio.com/chat/messages/"
#define kFirechatRooms @"https://mhacks-f2014.firebaseio.com/chat/rooms/"

@implementation MHChatRoomsViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
        
    // Initialize array that will store chat messages.
    self.chatRooms = [[NSMutableArray alloc] init];
    
    // Initialize the root of our Firebase namespace.
    self.firebase = [[Firebase alloc] initWithUrl:kFirechatRooms];
    
    [self.firebase observeEventType:FEventTypeChildAdded withBlock:^(FDataSnapshot *snapshot) {
        // Add the chat room to the array
        [self.chatRooms addObject:snapshot.value];
        
        // Reload the table view so the new message will show up.
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.roomsTableView reloadData];
            [self.roomsTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:self.chatRooms.count-1 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:NO];
        });
    }];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    NSIndexPath *indexPath = self.roomsTableView.indexPathForSelectedRow;
    if (indexPath) {
        [self.roomsTableView deselectRowAtIndexPath:indexPath animated:animated];
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
    UITableViewCell *cell = [table dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
    }
    
    NSDictionary* chatRoom = [self.chatRooms objectAtIndex:indexPath.row];
    
    cell.textLabel.text = chatRoom[@"title"];
    cell.detailTextLabel.text = chatRoom[@"details"];
    
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
        ((MHChatViewController*)segue.destinationViewController).firechatUrl = [[NSURL URLWithString:self.chatRoomToEnter relativeToURL:[NSURL URLWithString:kFirechatMessagesBase]] absoluteString];
        ((MHChatViewController*)segue.destinationViewController).navigationItem.title = self.chatRoomToEnter;
    }
}


@end
