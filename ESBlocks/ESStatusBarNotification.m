//
//  ESStatusBarNotification.m
//  ESBlocks
//
//  Created by Chi Zhang on 2/26/12.
//  Copyright (c) 2012 Chi Zhang. All rights reserved.
//

#import "ESStatusBarNotification.h"
#import "UIView+ESAdditions.h"

@interface ESStatusBarNotification ()
@property (strong, nonatomic) UILabel *textLabel;
@property (strong, nonatomic) UIImageView *imageView;
@property (strong, nonatomic) UIView *contentView;
@end

@implementation ESStatusBarNotification
@synthesize textLabel, imageView, contentView;
@synthesize appearDuration, lastDuration, disappearDuration;

#pragma mark - init
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.contentView = [[UIView alloc] initWithFrame:self.bounds];
        self.contentView.autoresizingMask = UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth;
        self.contentView.backgroundColor = [UIColor blackColor];
        self.imageView = [[UIImageView alloc] initWithFrame:CGRectZero];
        self.textLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        self.textLabel.backgroundColor = [UIColor clearColor];
        self.textLabel.textColor = [UIColor whiteColor];
        
        [self.contentView addSubview:self.imageView];
        [self.contentView addSubview:self.textLabel];
        [self addSubview:self.contentView];
        
        self.backgroundColor = [UIColor blackColor];
        self.appearDuration = 0.5;
        self.lastDuration = 1.0;
        self.disappearDuration = 0.3;
    }
    return self;
}

+ (ESStatusBarNotification *)notification
{
    CGRect frame = CGRectMake(0, 0, 320, 20);
    ESStatusBarNotification *notification = [[self alloc] initWithFrame:frame];
    return notification;
}

#pragma mark - public
- (void)show
{
    [self showAnimated:YES autoHide:YES];
}

- (void)showAnimated:(BOOL)animated autoHide:(BOOL)autoHide
{
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    window.windowLevel = UIWindowLevelStatusBar;
    [self removeFromSuperview];
    [window addSubview:self];
    [window sendSubviewToBack:self];
    ESLogd(@"window.bounds: %@", NSStringFromCGRect(window.bounds));
    if (animated) {
        self.contentView.top = self.height;
        [UIView animateWithDuration:self.appearDuration 
                         animations:^{
                             self.contentView.top = 0;
                         } 
                         completion:^(BOOL finished){
                             if (autoHide) {
                                 [self performSelector:@selector(hide) withObject:nil afterDelay:self.lastDuration];
                             }
                         }];
    }
}

- (void)hideImmediately
{
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    window.windowLevel = UIWindowLevelNormal;
    [self removeFromSuperview];
}

- (void)hide
{
    [self hideAnimated:YES];
}

- (void)hideAnimated:(BOOL)animated
{
    if (animated) {
        [UIView animateWithDuration:self.disappearDuration
                         animations:^{
                             self.contentView.top = self.height;
                         } 
                         completion:^(BOOL finished) {
                             [self hideImmediately];
                         }];
    } else {
        [self hideImmediately];
    }
}

#pragma mark -  accessors
- (void)setText:(NSString *)text
{
    self.textLabel.text = text;
}

- (NSString *)text
{
    return self.textLabel.text;
}

- (void)setNotificationIcon:(UIImage *)notificationIcon
{
    self.imageView.image = notificationIcon;
}

- (UIImage *)notificationIcon
{
    return self.imageView.image;
}

#pragma mark - UIView
- (void)layoutSubviews
{
    [super layoutSubviews];
    CGFloat height = self.contentView.height;
    self.imageView.height = height;
    self.imageView.width = height;
    self.textLabel.height = height;
    self.textLabel.width = self.contentView.width - self.imageView.width;
    self.textLabel.left = self.imageView.right;
}

@end
