//
//  DialogViewController.m
//  CustomizedAlertViewDemo
//
//  Created by Chi Zhang on 6/26/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "DialogViewController.h"
#import "UIViewController+ShowAsDialog.h"

@interface DialogViewController ()

@end

@implementation DialogViewController
@synthesize backgroundImageView;

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
    
    self.backgroundImageView.image = [[UIImage imageNamed:@"alert-view-bg-portrait"] stretchableImageWithLeftCapWidth:142 topCapHeight:31];
    self.view.backgroundColor = [UIColor redColor];
    NSLog(@"%@", NSStringFromSelector(_cmd));
}

- (void)viewDidUnload
{
    [self setBackgroundImageView:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (IBAction)cancelClicked:(id)sender
{
    [self dismissDialog];
}

@end
