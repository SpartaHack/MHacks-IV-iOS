//
//  ChatViewController.h
//  HSHacks
//
//  Created by Spencer Yen on 2/6/14.
//  Copyright (c) 2014 hshacks.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Firebase/Firebase.h>

@interface MHChatViewController : UIViewController

@property (nonatomic, strong) NSString* name;
@property (nonatomic, strong) NSString* photoURL;
@property (nonatomic, strong) NSMutableArray* chatMessages;
@property (nonatomic, strong) Firebase* firebase;

@property (strong, nonatomic) IBOutlet UITableView *chatTableView;
@property (strong, nonatomic) IBOutlet UITextField *chatTextField;

- (IBAction)logoutPressed:(id)sender;

@end
