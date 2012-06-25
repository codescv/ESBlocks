//
//  NSObject+ESBlocks.m
//  ESBlocks
//
//  Created by Chi Zhang on 6/21/12.
//  Copyright (c) 2012 Chi Zhang. All rights reserved.
//

#import "NSObject+ESBlocks.h"
#import "NSObject+ESPropertyGeneration.h"

@implementation NSObject (ESBlocks)

- (void)performBlock:(VoidBlock)block afterDelay:(NSTimeInterval)delay
{
    [self performSelector:@selector(__es_doBlock:) withObject:block afterDelay:delay];
}

- (void)__es_doBlock:(VoidBlock)block
{
    if (block) {
        block();
    }
}

@end
