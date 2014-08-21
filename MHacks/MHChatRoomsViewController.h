//
//  MHChatRoomsViewController.h
//  MHacks
//
//  Created by Ben Oztalay on 8/21/14.
//  Copyright (c) 2014 hshacks.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Firebase/Firebase.h>

@interface MHChatRoomsViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) Firebase* firebase;
@property (nonatomic, strong) NSMutableArray* chatRooms;

@property (nonatomic, strong) NSString* urlOfChatRoomToNavigateTo;

@property (strong, nonatomic) IBOutlet UITableView *roomsTableView;

@end
