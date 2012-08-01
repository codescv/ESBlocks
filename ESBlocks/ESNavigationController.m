//
//  ESNavigationController.m
//  ESBlocks
//
//  Created by Chi Zhang on 6/28/12.
//  Copyright (c) 2012 Chi Zhang. All rights reserved.
//

#import "ESNavigationController.h"
#import "UIView+ESAdditions.h"
#import "NSObject+ESPropertyGeneration.h"

@interface ESNavigationController ()

@property (strong, nonatomic) UIView *navigationBar;
@property (strong, nonatomic) UIView *containerView;

@end

@implementation ESNavigationController

@synthesize viewControllers = _viewControllers;
@synthesize navigationBarHeight = _navigationBarHeight;
@synthesize navigationBar = _navigationBar;
@synthesize containerView = _containerView;

- (id)initWithRootViewController:(UIViewController *)rootViewController
{
    self = [super init];
    if (self) {
        _viewControllers = [[NSMutableArray alloc] initWithObjects:rootViewController, nil];
        rootViewController.esNavigationController = self;
        _navigationBarHeight = 48;
    }
    return self;
}

- (UIViewController *)rootViewController
{
    return [self.viewControllers objectAtIndex:0];
}

- (UIViewController *)topViewController
{
    return [self.viewControllers lastObject];
}

- (void)loadView
{
    [super loadView];
    
    self.view.backgroundColor = [UIColor redColor];
    
    self.containerView = [[UIView alloc] initWithFrame:self.view.bounds];
    [self.view addSubview:self.containerView];
    
    if (self.topViewController) {
        [self.containerView addSubview:self.topViewController.view];
        self.navigationBar = self.topViewController.esNavigationBar;
    }
    
    if (!self.navigationBar) {
        self.navigationBar = [[UIView alloc] initWithFrame:self.view.bounds];
    }
    
    self.navigationBar.height = self.navigationBarHeight;
    self.navigationBar.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    self.navigationBar.backgroundColor = [UIColor blueColor];
    [self.containerView addSubview:self.navigationBar];
    
    self.navigationBar.frame = CGRectMake(0, 0, self.containerView.width, self.navigationBarHeight);
    self.topViewController.view.frame = CGRectMake(0, self.navigationBarHeight, self.containerView.width, self.containerView.height - self.navigationBarHeight);
    
    [self.view addSubview:self.containerView];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    if (self.topViewController) {
        return [self.topViewController shouldAutorotateToInterfaceOrientation:interfaceOrientation];        
    } else {
        return YES;
    }

}

- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    ESLogd(@"push view controller: %@", viewController);    
    viewController.esNavigationController = self;
    
    UIView *newContainerView = [[UIView alloc] initWithFrame:CGRectMake(self.view.width, 
                                                                        0,
                                                                        self.view.width,
                                                                        self.view.height)];
    
    
    [newContainerView addSubview:viewController.view];
    viewController.view.frame = newContainerView.bounds;
    [self.view addSubview:newContainerView];
    
    UIView *oldContainerView = self.containerView;
    self.containerView = newContainerView;

    [UIView animateWithDuration:1.0
                     animations:^{
                         oldContainerView.right = 0;
                         newContainerView.left = 0;
                     } completion:^(BOOL finished) {
                         [oldContainerView removeFromSuperview];
                     }];
    
    [self.viewControllers addObject:viewController];
}

- (UIViewController *)popViewControllerAnimated:(BOOL)animated
{
    if ([self.viewControllers count] <= 1) {
        return nil;
    }
    
    UIViewController *poppedViewController = [self.viewControllers lastObject];
    ESLogd(@"pop view controller: %@", poppedViewController);
    [self.viewControllers removeLastObject];
    
    UIViewController *showingViewController = [self.viewControllers lastObject];
    
    UIView *newContainerView = [[UIView alloc] initWithFrame:CGRectMake(-self.view.width, 
                                                                        0,
                                                                        self.view.width,
                                                                        self.view.height)];
    
    
    [newContainerView addSubview:showingViewController.view];
    showingViewController.view.frame = newContainerView.bounds;
    [self.view addSubview:newContainerView];
    
    UIView *oldContainerView = self.containerView;
    self.containerView = newContainerView;
    
    [UIView animateWithDuration:1.0
                     animations:^{
                         oldContainerView.left = self.view.width;
                         newContainerView.left = 0;
                     } completion:^(BOOL finished) {
                         [oldContainerView removeFromSuperview];
                     }];
    
    
    return poppedViewController;
}

@end

@implementation UIViewController (ESNavigationController)

@dynamic esNavigationController;
@dynamic esNavigationBar;

+ (void)initialize
{
    [self defineProperty:@"esNavigationController" type:ES_PROP_RETAIN];
    [self defineProperty:@"esNavigationBar" type:ES_PROP_RETAIN];
}

@end
