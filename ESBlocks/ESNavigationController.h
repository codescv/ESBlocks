//
//  ESNavigationController.h
//  ESBlocks
//
//  Created by Chi Zhang on 6/28/12.
//  Copyright (c) 2012 Chi Zhang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ESNavigationController : UIViewController

- (id)initWithRootViewController:(UIViewController *)rootViewController;

@property (strong, readonly, nonatomic) UIViewController *rootViewController;
@property (strong, readonly, nonatomic) UIViewController *topViewController;
@property (strong, readonly, nonatomic) NSMutableArray *viewControllers;
@property (assign, nonatomic) CGFloat navigationBarHeight;

- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated; // Uses a horizontal slide transition. Has no effect if the view controller is already in the stack.

- (UIViewController *)popViewControllerAnimated:(BOOL)animated; // Returns the popped controller.

@end

@interface UIViewController (ESNavigationController)

@property (strong, nonatomic) ESNavigationController *esNavigationController;
@property (strong, nonatomic) UIView *esNavigationBar;

@end
