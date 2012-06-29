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

@property (strong, nonatomic) UIViewController *rootViewController;
@property (strong, nonatomic) UIViewController *topViewController;
@property (copy, nonatomic) NSMutableArray *viewControllers;

@end

@implementation ESNavigationController

@synthesize rootViewController = _rootViewController;
@synthesize topViewController = _topViewController;
@synthesize viewControllers = _viewControllers;

- (id)initWithRootViewController:(UIViewController *)rootViewController
{
    self = [super init];
    if (self) {
        self.rootViewController = rootViewController;
        self.topViewController = rootViewController;
    }
    return self;
}

- (void)setRootViewController:(UIViewController *)rootViewController
{
    _rootViewController = rootViewController;
    _rootViewController.esNavigationController = self;
}

- (void)setTopViewController:(UIViewController *)topViewController
{
    _topViewController = topViewController;
    _topViewController.esNavigationController = self;
}

- (void)loadView
{
    [super loadView];
    
    NSLog(@"self: %@", NSStringFromCGRect(self.view.frame));
    
    self.view.backgroundColor = [UIColor redColor];
    
    UIView *navigationBar = [[UIView alloc] initWithFrame:self.view.bounds];
    navigationBar.height = 48;
    navigationBar.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    navigationBar.backgroundColor = [UIColor blueColor];
    [self.view addSubview:navigationBar];
    
    self.topViewController.view.frame = self.view.bounds;
    self.topViewController.view.top = 48;
    self.topViewController.view.height = self.view.height - 48;
    [self.view addSubview:self.topViewController.view];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return [self.topViewController shouldAutorotateToInterfaceOrientation:interfaceOrientation];
}

- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    NSLog(@"push view controller: %@", viewController);
    self.topViewController = viewController;
    self.topViewController.view.frame = self.view.bounds;
    self.topViewController.view.top = 48;
    self.topViewController.view.height = self.view.height - 48;
    [self.view addSubview:self.topViewController.view];
}

- (UIViewController *)popViewControllerAnimated:(BOOL)animated
{
    return nil;
}

@end

@implementation UIViewController (ESNavigationController)

@dynamic esNavigationController;

+ (void)load
{
    [self defineProperty:@"esNavigationController" type:ES_PROP_RETAIN];
}

@end
