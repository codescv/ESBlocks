//
//  NavContentViewController.m
//  ESBlocks
//
//  Created by Chi Zhang on 6/28/12.
//  Copyright (c) 2012 Chi Zhang. All rights reserved.
//

#import "NavContentViewController.h"
#import "ESNavigationController.h"

@interface NavContentViewController ()

@property (weak, nonatomic) IBOutlet UILabel *contentLabel;
- (IBAction)popButtonClicked:(id)sender;
- (IBAction)pushButtonClicked:(id)sender;

@end

@implementation NavContentViewController

@synthesize contentLabel = _contentLabel;
@synthesize content = _content;

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
    self.contentLabel.text = self.content;
}

- (void)viewDidUnload
{
    [self setContentLabel:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (IBAction)popButtonClicked:(id)sender 
{
    [self.esNavigationController popViewControllerAnimated:YES];
}

- (IBAction)pushButtonClicked:(id)sender
{
    NavContentViewController *cvc = [[NavContentViewController alloc] init];
    cvc.content = @"Pushed";
    NSLog(@"esnav: %@", self.esNavigationController);
    [self.esNavigationController pushViewController:cvc animated:YES];
}
@end
