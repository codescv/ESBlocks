//
//  ESKeyboardManager.h
//  iwo
//
//  Created by Chi Zhang on 4/11/12.
//  Copyright (c) 2012 FLK Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ESKeyboardManager : NSObject

+ (ESKeyboardManager *)sharedManager;
- (BOOL)isKeyboardVisible;
- (CGSize)keyboardSize;

- (void)dismissKeyboard;
- (CGFloat)keyboardTopInView:(UIView *)view;

- (CGFloat)keyboardTopInView:(UIView *)view forNotification:(NSNotification *)notif;
- (void)animateWithKeyboardNotification:(NSNotification *)notif animations:(void (^)(void))animations;

@end
