//
//  ESToast.m
//  ESBlocks
//
//  Created by Chi Zhang on 8/2/12.
//  Copyright (c) 2012 Chi Zhang. All rights reserved.
//

#import "ESToast.h"
#import "ESBlocks.h"

#import <QuartzCore/QuartzCore.h>

#define kMargin 4
#define kTransitionDuration 0.5

@interface ESToast ()

@property (strong, nonatomic) UIView *toastView;
@property (strong, nonatomic) UILabel *label;
@property (copy, nonatomic) NSString *text;
@property (assign, nonatomic) NSTimeInterval duration;

@end

@implementation ESToast

- (id)init
{
    self = [super init];
    if (self) {
        _toastView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 100, 40)];
        _toastView.backgroundColor = [UIColor blackColor];
        _toastView.layer.cornerRadius = 5;
        _label = [[UILabel alloc] initWithFrame:CGRectMake(5, 5, 80, 30)];
        _label.textColor = [UIColor whiteColor];
        _label.backgroundColor = [UIColor clearColor];
        [_toastView addSubview:_label];
    }
    return self;
}

- (void)show
{
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    [window addSubview:self.toastView];
    
    if ([[ESKeyboardManager sharedManager] isKeyboardVisible]) {
        self.toastView.center = CGPointMake(window.width/2, (window.height-[[ESKeyboardManager sharedManager] keyboardSize].height)/2);
    } else {
        self.toastView.center = CGPointMake(window.width/2, window.height/2);
    }
    
    self.toastView.alpha = 0;
    
    [UIView animateWithDuration:kTransitionDuration
                     animations:^{
                         self.toastView.alpha = 1;
                     } completion:^(BOOL finished) {
                         [UIView animateWithDuration:kTransitionDuration
                                               delay:self.duration
                                             options:UIViewAnimationOptionLayoutSubviews
                                          animations:^{
                                              self.toastView.alpha = 0;
                                          } completion:^(BOOL finished) {
                                              [self.toastView removeFromSuperview];
                                          }];
                     }];
}

- (void)setText:(NSString *)text
{
    self.label.text = text;
    [self.label sizeToFit];
    CGSize textSize = self.label.size;
    CGSize viewSize = CGSizeMake(textSize.width + 2 * kMargin, textSize.height + 2 * kMargin);
    self.toastView.size = viewSize;
    self.label.origin = CGPointMake(kMargin, kMargin);
}

+ (void)showToastWithText:(NSString *)text duration:(NSTimeInterval)duration
{
    ESToast *toast = [[ESToast alloc] init];
    toast.text = text;
    toast.duration = duration;
    [toast show];
}

@end
