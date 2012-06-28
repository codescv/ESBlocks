//
//  UIViewController+ShowAsPopup.h
//  ESBlocks
//
//  Created by Chi Zhang on 6/28/12.
//  Copyright (c) 2012 Chi Zhang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIViewController (ShowAsPopup)

- (void)showAsPopupFromPoint:(CGPoint)origin inView:(UIView *)view;

- (void)dismissPopup;

@end
