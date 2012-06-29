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

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)setContent:(NSString *)content
{
    self.contentLabel.text = content;
}

- (NSString *)content
{
    return self.contentLabel.text;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
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
    NavContentViewController *cvc = [[NavContentViewController alloc] init];
    cvc.content = @"Popped";
    [self.esNavigationController pushViewController:cvc animated:YES];
}

- (IBAction)pushButtonClicked:(id)sender
{
    
}
@end
