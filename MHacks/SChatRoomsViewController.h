//
//  SChatRoomsViewController.h
//  Sacks
//
//  Created by Ben Oztalay on 8/21/14.
//  Copyright (c) 2014 hshacks.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Firebase/Firebase.h>

@interface SChatRoomsViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, UIAlertViewDelegate>

@property (nonatomic, strong) Firebase* firebase;
@property (nonatomic, strong) NSMutableArray* chatRooms;
@property (nonatomic) BOOL hasInitialDataBeenLoaded;

@property (nonatomic, strong) NSString* chatRoomToEnter;

@property (strong, nonatomic) IBOutlet UITableView *roomsTableView;

@end