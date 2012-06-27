//
//  UIViewController+ShowAsDialog.m
//  CustomizedAlertViewDemo
//
//  Created by Chi Zhang on 6/26/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "UIViewController+ShowAsDialog.h"

@implementation UIViewController (ShowAsDialog)

static UIWindow *maskWindow = nil;
static UIWindow *disappearingMaskWindow = nil;
static UIViewController *dialogViewController = nil;
static UIViewController *disappearingDialogViewController = nil;
static CGFloat kTransitionDuration = 0.3f;

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

- (void)showAsDialog
{
    if (self.view == nil || maskWindow != nil) {
        // No view to show, or there is already an alert view shown
        return;
    }
    
    dialogViewController = self;
    
    maskWindow = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    maskWindow.windowLevel = UIWindowLevelStatusBar;
    maskWindow.backgroundColor = [UIColor clearColor];
    maskWindow.alpha = 0.0f;
    
    UIView *dialogBackgroundView = [[UIView alloc] initWithFrame:maskWindow.bounds];
    dialogBackgroundView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.6];
    [dialogBackgroundView addSubview:self.view];
    
    [maskWindow addSubview:dialogBackgroundView];
    [maskWindow makeKeyAndVisible];
    
    self.view.transform = CGAffineTransformScale([self transformForOrientation], 0.001, 0.001);
    self.view.center = dialogBackgroundView.center;
    
    if ([self respondsToSelector:@selector(viewWillAppearAsDialog)]) {
        [self viewWillAppearAsDialog];
    }
        
    // Pop animation: dialog size from 1.0 -> 1.1 -> 0.9 -> 1.0
    [UIView animateWithDuration:kTransitionDuration/1.5
                     animations:^{
                         self.view.transform = CGAffineTransformScale([self transformForOrientation], 1.1, 1.1);
                         maskWindow.alpha = 1.0f;
                     } 
                     completion:^(BOOL finished) {
                         [UIView animateWithDuration:kTransitionDuration/2
                                          animations:^{
                                              self.view.transform = CGAffineTransformScale([self transformForOrientation], 0.9, 0.9);
                                          } 
                                          completion:^(BOOL finished) {
                                              [UIView animateWithDuration:kTransitionDuration/2
                                                               animations:^{
                                                                   self.view.transform = [self transformForOrientation];
                                                               } 
                                                               completion:^(BOOL finished) {
                                                                   if ([self respondsToSelector:@selector(viewDidAppearAsDialog)]) {
                                                                       [self viewDidAppearAsDialog];
                                                                   }
                                                               }];
                                          }];
                         
                         
                     }];
}

- (void)dismissDialog
{
    if (!maskWindow || !dialogViewController) {
        // be nice
        // ignore when no dialog is shown
        return;
    }
        
    disappearingDialogViewController = dialogViewController;
    dialogViewController = nil;
    
    disappearingMaskWindow = maskWindow;
    maskWindow = nil;
    
    if ([self respondsToSelector:@selector(viewWillDisappearAsDialog)]) {
        [disappearingDialogViewController viewWillDisappearAsDialog];
    }
    
    [UIView animateWithDuration:kTransitionDuration/2
                     animations:^{
                         disappearingMaskWindow.alpha = 0.0f;
                     } 
                     completion:^(BOOL finished) {
                         disappearingMaskWindow.windowLevel = UIWindowLevelNormal;
                         disappearingMaskWindow = nil;
                         [[[UIApplication sharedApplication].delegate window] makeKeyAndVisible];
                         if ([self respondsToSelector:@selector(viewDidDisappearAsDialog)]) {
                             [disappearingDialogViewController viewDidDisappearAsDialog];
                         }
                         disappearingDialogViewController = nil;
                     }];
}

@end
