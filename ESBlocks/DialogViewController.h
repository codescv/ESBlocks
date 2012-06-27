//
//  DialogViewController.h
//  ESBlocks
//
//  Created by Chi Zhang on 6/26/12.
//  Copyright (c) 2012 Chi Zhang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DialogViewController : UIViewController
@property (retain, nonatomic) IBOutlet UIImageView *backgroundImageView;
- (IBAction)cancelClicked:(id)sender;
- (IBAction)okClicked:(id)sender;

@end
