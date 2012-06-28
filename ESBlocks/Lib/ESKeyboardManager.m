//
//  ESKeyboardManager.m
//  iwo
//
//  Manages keyboard disappearing and appearing
//  Created by Chi Zhang on 4/11/12.
//  Copyright (c) 2012 FLK Inc. All rights reserved.
//

#import "ESKeyboardManager.h"

#import "UIView+ESAdditions.h"
#import "SynthesizeSingleton.h"
#import "ESLog.h"

@interface ESKeyboardManager ()
@property (nonatomic, assign) BOOL isKeyboardVisible;
@property (nonatomic, assign) CGSize keyboardSize;
@property (nonatomic, assign) CGRect keyboardFrame;
@end

@implementation ESKeyboardManager

SYNTHESIZE_SINGLETON_FOR_CLASS(ESKeyboardManager);

@synthesize isKeyboardVisible = _isKeyboardVisible;
@synthesize keyboardSize = _keyboardSize;
@synthesize keyboardFrame = _keyboardFrame;

+ (void)load
{
    @autoreleasepool {
        // ensure notifications are registered
        [self sharedManager];
    }
}

- (id)init
{
    self = [super init];
    if (self) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidShow:)
                                                     name:UIKeyboardDidShowNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:)
                                                     name:UIKeyboardWillShowNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:)
                                                     name:UIKeyboardWillHideNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidHide:)
                                                     name:UIKeyboardDidHideNotification object:nil];
    }
    return self;
}

+ (ESKeyboardManager *)sharedManager
{
    return [ESKeyboardManager sharedESKeyboardManager];
}

- (void)updateKeyboardSize:(NSNotification *)notif
{
    NSDictionary* info = [notif userInfo];
    NSValue* aVal = [info objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect frame = [aVal CGRectValue];
    self.keyboardFrame = frame;
    self.keyboardSize = frame.size;
}

- (void)animateWithKeyboardNotification:(NSNotification *)notif animations:(void (^)(void))animations
{
    NSTimeInterval animationDuration = [[notif.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    [UIView animateWithDuration:animationDuration animations:animations];
}

- (CGFloat)keyboardTopInView:(UIView *)view forNotification:(NSNotification *)notif
{
    NSDictionary* info = [notif userInfo];
    NSValue* aVal = [info objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect frame = [aVal CGRectValue];
    CGRect r = [view convertRect:frame fromView:[UIApplication sharedApplication].keyWindow];
    return r.origin.y;
}

- (CGFloat)keyboardTopInView:(UIView *)view
{
    if (self.isKeyboardVisible) {
        CGRect r = [view convertRect:self.keyboardFrame fromView:[UIApplication sharedApplication].keyWindow];
        return r.origin.y;
    } else {
        return view.height;
    }
}

- (void)dismissKeyboard
{
    [[UIApplication sharedApplication].keyWindow findAndResignFirstResponder];
}

- (void)keyboardDidShow:(NSNotification *)notif
{
    self.isKeyboardVisible = YES;
    [self updateKeyboardSize:notif];
}

- (void)keyboardDidHide:(NSNotification *)notif
{
    self.isKeyboardVisible = NO;
}

- (void)keyboardWillShow:(NSNotification *)notif
{
    [self updateKeyboardSize:notif];
}

- (void)keyboardWillHide:(NSNotification *)notif
{
    self.isKeyboardVisible = NO;
}

@end
