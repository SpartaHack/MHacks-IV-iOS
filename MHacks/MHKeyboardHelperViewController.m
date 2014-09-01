//
//  MHKeyboardHelperViewController.m
//  MHacks
//
//  Created by Ben Oztalay on 9/1/14.
//  Copyright (c) 2014 hshacks.com. All rights reserved.
//

#import "MHKeyboardHelperViewController.h"
#import "DAKeyboardControl.h"
#import "UIResponder+FirstResponder.h"

#define KEYBOARD_VERTICAL_BUFFER 7.0f

@interface MHKeyboardHelperViewController ()

@property (strong, nonatomic) NSMutableArray* viewsToMoveWithKeyboard;
@property (strong, nonatomic) NSMutableArray* originalFramesOfViews;

@end

@implementation MHKeyboardHelperViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.viewsToMoveWithKeyboard = [[NSMutableArray alloc] init];
    self.originalFramesOfViews = [[NSMutableArray alloc] init];
    
    UITapGestureRecognizer* tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(backgroundTapped)];
    [self.view addGestureRecognizer:tapRecognizer];
}

- (void)viewWillAppear:(BOOL)animated
{
    __weak MHKeyboardHelperViewController* weakSelf = self;
    
    [self.view addKeyboardPanningWithActionHandler:^(CGRect keyboardFrameInView, BOOL opening, BOOL closing) {
        UIView* firstResponder = [UIResponder currentFirstResponder];
        
        if(firstResponder != nil) {
            CGRect originalFirstResponderFrame = [weakSelf.view convertRect:[weakSelf getFrameOfView:firstResponder] fromView:firstResponder.superview];
            CGFloat bottomYOfBufferedFrame = originalFirstResponderFrame.origin.y + originalFirstResponderFrame.size.height + KEYBOARD_VERTICAL_BUFFER;
            
            CGFloat verticalOffset = keyboardFrameInView.origin.y - bottomYOfBufferedFrame;
            if(verticalOffset > 0.0f) {
                verticalOffset = 0.0f;
            }
            
            for(int i = 0; i < [weakSelf viewsToMoveWithKeyboard].count; i++) {
                [weakSelf offsetView:[[weakSelf viewsToMoveWithKeyboard] objectAtIndex:i]
                        verticallyBy:verticalOffset
                   fromOriginalFrame:[[[weakSelf originalFramesOfViews] objectAtIndex:i] CGRectValue]];
            }
        }
    }];
}

- (CGRect)getFrameOfView:(UIView*)view
{
    NSInteger indexOfView = [self.viewsToMoveWithKeyboard indexOfObject:view];
    if(indexOfView != NSNotFound) {
        return [[self.originalFramesOfViews objectAtIndex:indexOfView] CGRectValue];
    } else {
        return CGRectMake(0.0f, 0.0f, 0.0f, 0.0f);
    }
}

- (void)offsetView:(UIView*)view verticallyBy:(CGFloat)offset fromOriginalFrame:(CGRect)originalFrame
{
    CGRect newViewFrame = view.frame;
    newViewFrame.origin.y = originalFrame.origin.y + offset;
    view.frame = newViewFrame;
}

- (void)registerViewToMoveWithKeyboard:(UIView*)view
{
    [self.viewsToMoveWithKeyboard addObject:view];
    [self.originalFramesOfViews addObject:[NSValue valueWithCGRect:view.frame]];
}

- (void)backgroundTapped
{
    [self.view hideKeyboard];
}

- (void)dismissKeyboard
{
    [self.view hideKeyboard];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [self.view removeKeyboardControl];
}

@end
