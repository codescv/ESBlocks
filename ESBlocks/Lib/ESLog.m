//
//  ESLog.m
//  ESBlocks
//
//  Created by Chi Zhang on 1/3/12.
//  Copyright (c) 2012 Chi Zhang. All rights reserved.
//

#import "ESLog.h"

@implementation ESLog

+ (void)logWithLevel:(int)level
     currentLoglevel:(int)currentLevel
                file:(const char*)file
                line:(uint)line
              format:(NSString *)format, ...
{
    if (currentLevel < level) {
        return;
    }
    
    va_list args;
	if (format) {
		va_start(args, format);
        NSString *filename = [[NSURL fileURLWithPath:[NSString stringWithCString:file 
                                                                        encoding:NSUTF8StringEncoding]]
                              lastPathComponent];
		NSString *logMsg = [[NSString alloc] initWithFormat:format arguments:args];
        id thread = [NSThread isMainThread] ? @"MainThread" : [NSThread currentThread];
        NSLog(@"[%@:%@:%d:]%@", thread, filename, line, logMsg);
		va_end(args);
	}

}

@end
