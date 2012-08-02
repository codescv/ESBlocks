//
//  ESToast.h
//  ESBlocks
//
//  A notification like the 'toast' on android.
//
//  Created by Chi Zhang on 8/2/12.
//  Copyright (c) 2012 Chi Zhang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ESToast : NSObject

+ (void)showToastWithText:(NSString *)text duration:(NSTimeInterval)duration;

@end
