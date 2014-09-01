//
//  MHKeyboardHelperViewController.h
//  MHacks
//
//  Created by Ben Oztalay on 9/1/14.
//  Copyright (c) 2014 hshacks.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MHKeyboardHelperViewController : UIViewController

- (void)registerViewToMoveWithKeyboard:(UIView*)view;
- (void)dismissKeyboard;

@end