//
//  ChatViewController.h
//  HSHacks
//
//  Created by Spencer Yen on 2/6/14.
//  Copyright (c) 2014 hshacks.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Firebase/Firebase.h>

@interface MHChatViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) NSString* firechatUrl;

@property (strong, nonatomic) NSString* name;
@property (strong, nonatomic) NSString* photoURL;
@property (strong, nonatomic) NSMutableArray* chatMessages;
@property (strong, nonatomic) Firebase* firebase;

@property (strong, nonatomic) IBOutlet UITableView *chatTableView;
@property (strong, nonatomic) IBOutlet UITextField *chatTextField;

@end
