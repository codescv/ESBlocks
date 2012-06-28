//
//  DialogViewController.m
//  ESBlocks
//
//  Created by Chi Zhang on 6/26/12.
//  Copyright (c) 2012 Chi Zhang. All rights reserved.
//

#import "DialogViewController.h"
#import "UIViewController+ShowAsDialog.h"

#import "ESLog.h"

@interface DialogViewController ()

@property (strong, nonatomic) IBOutlet UIImageView *backgroundImageView;
- (IBAction)cancelClicked:(id)sender;
- (IBAction)okClicked:(id)sender;

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
    self.backgroundImageView.image = [[UIImage imageNamed:@"alert-view-bg-portrait.png"] stretchableImageWithLeftCapWidth:142 topCapHeight:31];
}

- (void)viewDidUnload
{
    [self setBackgroundImageView:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillDisappearAsDialog
{
    ESLogt();
    //ESLogtt();
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (IBAction)cancelClicked:(id)sender
{
    [self dismissDialog];
}

- (IBAction)okClicked:(id)sender 
{
    [self dismissDialog];
    DialogViewController *dvc = [[DialogViewController alloc] init];
    [dvc showAsDialog];
}

@end
