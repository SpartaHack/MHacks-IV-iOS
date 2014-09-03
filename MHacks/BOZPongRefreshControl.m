//
//  BOZPongRefreshControl.m
//  Ben Oztalay
//
//  Created by Ben Oztalay on 11/22/13.
//  Copyright (c) 2013 Ben Oztalay. All rights reserved.
//
//  Version 1.0.0
//  https://www.github.com/boztalay/BOZPongRefreshControl
//

#import "BOZPongRefreshControl.h"
#import "MHUpdatesViewController.h"
#import "UIColor+MHacksColors.h"

#define REFRESH_CONTROL_HEIGHT 65.0f
#define HALF_REFRESH_CONTROL_HEIGHT (REFRESH_CONTROL_HEIGHT / 2.0f)

#define DEFAULT_FOREGROUND_COLOR [UIColor whiteColor]
#define DEFAULT_BACKGROUND_COLOR [UIColor datOrangeColor]

#define TRANSITION_ANIMATION_DURATION 0.2f

#define ANIMATION_FRAME_FORMAT @"frame-%d.png"
#define TOTAL_NUMBER_OF_FRAMES 182

typedef enum {
    BOZPongRefreshControlStateIdle = 0,
    BOZPongRefreshControlStateRefreshing = 1,
    BOZPongRefreshControlStateResetting = 2
} BOZPongRefreshControlState;

static NSMutableArray* animationFrames;

@interface BOZPongRefreshControl() {
    BOZPongRefreshControlState state;
    
    CGFloat originalTopContentInset;

    UIView* gameView;
    UIImageView* logoView;
}

@property (strong, nonatomic) UIScrollView* scrollView;
@property (strong, nonatomic) id refreshTarget;
@property (nonatomic) SEL refreshAction;
@property (nonatomic, readonly) CGFloat distanceScrolled;

@end

@implementation BOZPongRefreshControl

#pragma mark - Attaching a pong refresh control to a UIScrollView or UITableView

#pragma mark UITableView

+ (BOZPongRefreshControl*)attachToTableView:(UITableView*)tableView
                          withRefreshTarget:(id)refreshTarget
                           andRefreshAction:(SEL)refreshAction
{
    return [self attachToScrollView:tableView
                  withRefreshTarget:refreshTarget
                   andRefreshAction:refreshAction];
}

#pragma mark UIScrollView

+ (BOZPongRefreshControl*)attachToScrollView:(UIScrollView*)scrollView
                           withRefreshTarget:(id)refreshTarget
                            andRefreshAction:(SEL)refreshAction
{
    BOZPongRefreshControl* existingPongRefreshControl = [self findPongRefreshControlInScrollView:scrollView];
    if(existingPongRefreshControl != nil) {
        return existingPongRefreshControl;
    }
    
    //Initialized height to 0 to hide it
    BOZPongRefreshControl* pongRefreshControl = [[BOZPongRefreshControl alloc] initWithFrame:CGRectMake(0.0f, 0.0f, scrollView.frame.size.width, 0.0f)
                                                                               andScrollView:scrollView
                                                                            andRefreshTarget:refreshTarget
                                                                            andRefreshAction:refreshAction];

    [scrollView addSubview:pongRefreshControl];

    return pongRefreshControl;
}

+ (BOZPongRefreshControl*)findPongRefreshControlInScrollView:(UIScrollView*)scrollView
{
    for(UIView* subview in scrollView.subviews) {
        if([subview isKindOfClass:[BOZPongRefreshControl class]]) {
            return (BOZPongRefreshControl*)subview;
        }
    }
    
    return nil;
}

#pragma mark - Initializing a new pong refresh control

- (id)initWithFrame:(CGRect)frame
      andScrollView:(UIScrollView*)scrollView
   andRefreshTarget:(id)refreshTarget
   andRefreshAction:(SEL)refreshAction
{
    self = [super initWithFrame:frame];
    if (self) {
        self.clipsToBounds = YES;
        
        self.scrollView = scrollView;
        self.refreshTarget = refreshTarget;
        self.refreshAction = refreshAction;
        
        originalTopContentInset = scrollView.contentInset.top;
        
        if (animationFrames == nil) {
            animationFrames = [[NSMutableArray alloc] init];
            for (int i = 0; i < TOTAL_NUMBER_OF_FRAMES; i++) {
                NSString* frameName = [NSString stringWithFormat:ANIMATION_FRAME_FORMAT, i];
                [animationFrames addObject:[UIImage imageNamed:frameName]];
            }
        }
        
        [self setUpViews];
        
        state = BOZPongRefreshControlStateIdle;
        
        self.foregroundColor = DEFAULT_FOREGROUND_COLOR;
        self.backgroundColor = DEFAULT_BACKGROUND_COLOR;
        
    }
    return self;
}

- (void)setUpViews
{
    gameView = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, self.frame.size.width, REFRESH_CONTROL_HEIGHT)];
    gameView.backgroundColor = [UIColor clearColor];
    [self addSubview:gameView];
    
    CGFloat logoSize = gameView.frame.size.height * 0.75f;
    logoView = [[UIImageView alloc] initWithFrame:CGRectMake((gameView.frame.size.width / 2.0f) - (logoSize / 2.0f),
                                                             (gameView.frame.size.height - logoSize) / 2.0f,
                                                             logoSize, logoSize)];
    [gameView addSubview:logoView];
}

#pragma mark - Handling various configuration changes

- (void)setBackgroundColor:(UIColor *)backgroundColor
{
    [super setBackgroundColor:backgroundColor];
}

- (void)setForegroundColor:(UIColor*)foregroundColor
{
    _foregroundColor = foregroundColor;
}

- (void)resetColors:(MHUpdatesViewController*)viewController
{
    if (viewController.bar.tintColor == [UIColor whiteColor]) {
        //Back To Normal?
        [viewController.bar setTintColor:[UIColor datOrangeColor]];
        viewController.bar.barTintColor = [UIColor whiteColor];
        viewController.bar.titleTextAttributes = @{NSForegroundColorAttributeName: [UIColor blackColor]};
        viewController.bar.topItem.title = @"Updates";
        [super setBackgroundColor:[UIColor datOrangeColor]];
        _foregroundColor = [UIColor whiteColor];
    }else{
        [viewController.bar setTintColor:[UIColor whiteColor]];
        viewController.bar.barTintColor = [UIColor colorWithRed:0 green:0.429 blue:0.143 alpha:1];
        viewController.bar.titleTextAttributes = @{NSForegroundColorAttributeName: [UIColor whiteColor]};
        viewController.bar.topItem.title = @"GO GREEN GO WHITE";
        [super setBackgroundColor:[UIColor colorWithRed:0 green:0.429 blue:0.143 alpha:1]];
        _foregroundColor = [UIColor whiteColor];
    }
}

#pragma mark - Listening to scroll delegate events

#pragma mark Actively scrolling

- (void)scrollViewDidScroll
{
    CGFloat rawOffset = -self.distanceScrolled;
    
    [self offsetGameViewBy:rawOffset];
    
    if(state == BOZPongRefreshControlStateIdle) {
        CGFloat proportionPulled = MIN((rawOffset / 2.0f) / HALF_REFRESH_CONTROL_HEIGHT, 1.0f);
        
        NSInteger currentFrame = floorf(proportionPulled * (TOTAL_NUMBER_OF_FRAMES - 1));
        logoView.image = [animationFrames objectAtIndex:currentFrame];
    }
}

- (CGFloat)distanceScrolled
{
    return (self.scrollView.contentOffset.y + self.scrollView.contentInset.top);
}

- (void)offsetGameViewBy:(CGFloat)offset
{
    CGFloat offsetConsideringState = offset;
    if(state != BOZPongRefreshControlStateIdle) {
        offsetConsideringState += REFRESH_CONTROL_HEIGHT;
    }
    
    [self setHeightAndOffsetOfRefreshControl:offsetConsideringState];
    [self stickGameViewToBottomOfRefreshControl];
}

- (void)setHeightAndOffsetOfRefreshControl:(CGFloat)offset
{
    CGRect newFrame = self.frame;
    newFrame.size.height = offset;
    newFrame.origin.y = -offset;
    self.frame = newFrame;
}

- (void)stickGameViewToBottomOfRefreshControl
{
    CGRect newGameViewFrame = gameView.frame;
    newGameViewFrame.origin.y = self.frame.size.height - gameView.frame.size.height;
    gameView.frame = newGameViewFrame;
}

#pragma mark Letting go of the scroll view, checking for refresh trigger

- (void)scrollViewDidEndDragging
{
    if(state == BOZPongRefreshControlStateIdle) {
        if([self didUserScrollFarEnoughToTriggerRefresh]) {
            [self beginLoading];
            [self notifyTargetOfRefreshTrigger];
        }
    }
}

- (BOOL)didUserScrollFarEnoughToTriggerRefresh
{
    return (-self.distanceScrolled > REFRESH_CONTROL_HEIGHT);
}

- (void)notifyTargetOfRefreshTrigger
{
    #pragma clang diagnostic push
    #pragma clang diagnostic ignored "-Warc-performSelector-leaks"
    
    if ([self.refreshTarget respondsToSelector:self.refreshAction])
        [self.refreshTarget performSelector:self.refreshAction];
    
    #pragma clang diagnostic pop
}

#pragma mark - Manually starting a refresh

- (void)beginLoading
{
    [self beginLoadingAnimated:YES];
}

- (void)beginLoadingAnimated:(BOOL)animated
{
    if (state != BOZPongRefreshControlStateRefreshing) {
        state = BOZPongRefreshControlStateRefreshing;

        [self scrollRefreshControlToVisibleAnimated:animated];
        [self startPong];
    }
}

- (void)scrollRefreshControlToVisibleAnimated:(BOOL)animated
{
    CGFloat animationDuration = 0.0f;
    if(animated) {
        animationDuration = TRANSITION_ANIMATION_DURATION;
    }
    
    [UIView animateWithDuration:animationDuration animations:^(void) {
        UIEdgeInsets newInsets = self.scrollView.contentInset;
        newInsets.top = originalTopContentInset + REFRESH_CONTROL_HEIGHT;
        self.scrollView.contentInset = newInsets;
    }];
}

#pragma mark - Resetting after loading finished

- (void)finishedLoading
{
    if(state != BOZPongRefreshControlStateRefreshing) {
        return;
    }
    
    state = BOZPongRefreshControlStateResetting;
    
    [UIView animateWithDuration:TRANSITION_ANIMATION_DURATION animations:^(void)
     {
         [self resetScrollViewContentInsets];
         [self setHeightAndOffsetOfRefreshControl:0.0f];
     }
     completion:^(BOOL finished)
     {
         [self resetPaddlesAndBall];
         state = BOZPongRefreshControlStateIdle;
     }];
}

- (void)resetScrollViewContentInsets
{
    UIEdgeInsets newInsets = self.scrollView.contentInset;
    newInsets.top = originalTopContentInset;
    self.scrollView.contentInset = newInsets;
}

- (void)resetPaddlesAndBall
{
    [self removeAnimations];
    
    //TODO reset here
}

- (void)removeAnimations
{
    [logoView.layer removeAllAnimations];
}

#pragma mark - Wiggle wiggle

- (void)startPong
{
    //TODO wiggle here
}

@end
