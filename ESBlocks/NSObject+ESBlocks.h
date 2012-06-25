//
//  NSObject+ESBlocks.h
//  ESBlocks
//
//  Created by Chi Zhang on 6/21/12.
//  Copyright (c) 2012 Chi Zhang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ESBlocks.h"

@interface NSObject (ESBlocks)

- (void)performBlock:(VoidBlock)block afterDelay:(NSTimeInterval)delay;

@end