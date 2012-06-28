//
//  UIViewController+ShowAsPopup.m
//  ESBlocks
//
//  Created by Chi Zhang on 6/28/12.
//  Copyright (c) 2012 Chi Zhang. All rights reserved.
//

#import "UIViewController+ShowAsPopup.h"

@implementation UIViewController (ShowAsPopup)

static const CGFloat kAnimationDuration = 0.2f;

- (CGAffineTransform)transformForOrientation {
	UIInterfaceOrientation orientation = [UIApplication sharedApplication].statusBarOrientation;
	if (orientation == UIInterfaceOrientationLandscapeLeft) {
		return CGAffineTransformMakeRotation(M_PI*1.5);
	} else if (orientation == UIInterfaceOrientationLandscapeRight) {
		return CGAffineTransformMakeRotation(M_PI/2);
	} else if (orientation == UIInterfaceOrientationPortraitUpsideDown) {
		return CGAffineTransformMakeRotation(-M_PI);
	} else {
		return CGAffineTransformIdentity;
	}
}

- (void)showAsPopupFromPoint:(CGPoint)origin inView:(UIView *)view;
{
    UIWindow *window = [[UIApplication sharedApplication] keyWindow];
    
    UIView *rootView = window;
    UIButton * backgroundButton = [[UIButton alloc] initWithFrame:rootView.bounds];
    [backgroundButton addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [rootView addSubview:backgroundButton];
    [backgroundButton addSubview:self.view];
    
    CGPoint target = [backgroundButton convertPoint:origin fromView:view];
    self.view.center = target;
    self.view.transform = [self transformForOrientation];
    self.view.alpha = 0;
    [UIView animateWithDuration:kAnimationDuration
                     animations:^{
                         self.view.alpha = 1; 
                     }];
}

- (void)dismissPopup
{
    [UIView animateWithDuration:kAnimationDuration
                     animations:^{
                         self.view.alpha = 0;
                     }
                     completion:^(BOOL finished) {
                         [self.view.superview removeFromSuperview];
                         [self.view removeFromSuperview];
                     }];
}

- (void)buttonClicked:(id)button
{
    [self dismissPopup];
}

@end
