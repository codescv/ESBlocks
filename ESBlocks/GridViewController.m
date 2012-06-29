//
//  GridViewController.m
//  ESBlocks
//
//  Created by Chi Zhang on 6/28/12.
//  Copyright (c) 2012 Chi Zhang. All rights reserved.
//

#import "GridViewController.h"
#import "UIViewController+ESAdditions.h"
#import "UIBarButtonItem+ESBlocks.h"

@interface GridViewController ()

@property (strong, nonatomic) ESGridView *gridView;

@end

@implementation GridViewController

@synthesize gridView = _gridView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.gridView = [[ESGridView alloc] initWithFrame:self.view.bounds];
    self.gridView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    self.gridView.delegate = self;
    [self.view addSubview:self.gridView];
    
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem barButtonItemWithTitle:@"Dismiss"
                                                                              style:UIBarButtonItemStyleBordered
                                                                              block:^{
                                                                                  [self dismissAsModalViewControllerAnimated:YES];
                                                                              }];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    self.gridView = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return YES;
}

#pragma mark - grid view delegate
- (NSUInteger)numberOfCellsInGridView:(ESGridView *)gridView
{
    return 40;
}

- (UIView *)gridView:(ESGridView *)gridView cellAtIndex:(NSUInteger)index
{
    UILabel *label = [[UILabel alloc] init];
    label.text = [NSString stringWithFormat:@"Grid_%d", index];
    int c = index % 3;
    if (c == 0) {
        label.backgroundColor = [UIColor redColor];
    } else if (c == 1) {
        label.backgroundColor = [UIColor blueColor];
    } else {
        label.backgroundColor = [UIColor whiteColor];
    }
    return label;
}

- (CGSize)cellSizeForGridView:(ESGridView *)gridView
{
    return CGSizeMake(80, 80);
}


@end
