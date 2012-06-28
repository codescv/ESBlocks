//
//  PopupViewController.m
//  ESBlocks
//
//  Created by Chi Zhang on 6/28/12.
//  Copyright (c) 2012 Chi Zhang. All rights reserved.
//

#import "PopupViewController.h"

@interface PopupViewController ()

- (IBAction)photoClicked:(id)sender;
- (IBAction)videoClicked:(id)sender;

@end

@implementation PopupViewController

@synthesize onPhoto = _onPhoto;
@synthesize onVideo = _onVideo;

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
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (IBAction)photoClicked:(id)sender
{
    if (self.onPhoto) {
        self.onPhoto();
    }
}

- (IBAction)videoClicked:(id)sender
{
    if (self.onVideo) {
        self.onVideo();
    }
}

@end
