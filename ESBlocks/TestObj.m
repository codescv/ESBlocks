//
//  TestObj.m
//  ESBlocks
//
//  Created by Chi Zhang on 6/21/12.
//  Copyright (c) 2012 Chi Zhang. All rights reserved.
//

#import "TestObj.h"
#import "ESLog.h"

@implementation TestObj

@synthesize name;

- (void)dealloc
{
    ESLogd(@"dealloc: %@", self.name);
}

@end
