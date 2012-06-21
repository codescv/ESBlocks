//
//  TestObj.m
//  ESBlocks
//
//  Created by Chi Zhang on 6/21/12.
//  Copyright (c) 2012 Chi Zhang. All rights reserved.
//

#import "TestObj.h"

@implementation TestObj

@synthesize name;

- (void)dealloc
{
    NSLog(@"dealloc: %@", self.name);
}

@end
