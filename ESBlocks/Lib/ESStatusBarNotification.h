//
//  ESStatusBarNotification.h
//  ESBlocks
//
//  Created by Chi Zhang on 2/26/12.
//  Copyright (c) 2012 Chi Zhang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface ESStatusBarNotification : UIView {
@private
    UIView *contentView;
    UILabel *textLabel;
    UIImageView *imageView;
    NSTimeInterval appearDuration;
    NSTimeInterval lastDuration;
    NSTimeInterval disappearDuration;
}

// convenience contructor
+ (ESStatusBarNotification *)notification;

// notification properties
@property (strong, nonatomic) NSString *text;
@property (strong, nonatomic) UIImage *notificationIcon;
@property (assign, nonatomic) NSTimeInterval appearDuration;
@property (assign, nonatomic) NSTimeInterval lastDuration;
@property (assign, nonatomic) NSTimeInterval disappearDuration;

// shows the notification.
- (void)showAnimated:(BOOL)animated autoHide:(BOOL)autoHide;
// shortcut for showAnimated:YES autoHide:YES
- (void)show;
// hides the notification
- (void)hideAnimated:(BOOL)animated;
// shortcut for hideAnimated:YES
- (void)hide;
// hide immediately
- (void)hideImmediately;

@end