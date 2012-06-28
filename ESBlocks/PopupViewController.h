//
//  PopupViewController.h
//  ESBlocks
//
//  Created by Chi Zhang on 6/28/12.
//  Copyright (c) 2012 Chi Zhang. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^PopupDelegate)();

@interface PopupViewController : UIViewController

@property (copy, nonatomic) PopupDelegate onPhoto;
@property (copy, nonatomic) PopupDelegate onVideo;

@end
