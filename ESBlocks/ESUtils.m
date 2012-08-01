//
//  ESUtils.m
//  ESBlocks
//
//  Created by Chi Zhang on 7/27/12.
//  Copyright (c) 2012 Chi Zhang. All rights reserved.
//

#import "ESUtils.h"

NSString* ESPathForBundleFile(NSString* relativePath) {
    NSString* resourcePath = [[NSBundle mainBundle] resourcePath];
    return [resourcePath stringByAppendingPathComponent:relativePath];
}


NSString* ESPathForDocumentsFile(NSString* relativePath) {
    static NSString* documentsPath = nil;
    if (nil == documentsPath) {
        NSArray* dirs = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        documentsPath = [dirs objectAtIndex:0];
    }
    return [documentsPath stringByAppendingPathComponent:relativePath];
}

NSString* ESPathForTemporaryFile(NSString* relativePath)
{
    [relativePath lastPathComponent];
    return [NSTemporaryDirectory() stringByAppendingPathComponent:relativePath];
}
