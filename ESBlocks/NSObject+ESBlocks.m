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
    [self performSelector:@selector(doBlock:) withObject:block afterDelay:delay];
}

- (void)doBlock:(VoidBlock)block
{
    if (block) {
        block();
    }
}

- (void)registerNotification:(NSString *)name usingBlock:(NotificationCallbackBlock)block
{
    /*__block __weak id obj;
    obj =*/ [[NSNotificationCenter defaultCenter] addObserverForName:name
                                                            object:nil
                                                             queue:nil
                                                        usingBlock:block];
}

- (void)unregisterNotification:(NSString *)name
{
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:name
                                                  object:nil];
}

@end
