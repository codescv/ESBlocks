//
//  ESLog.h
//  ESBlocks
//
//  Created by Chi Zhang on 1/3/12.
//  Copyright (c) 2012 Chi Zhang. All rights reserved.
//
//  ESLog is a light-weight logging tool to facilitate logging operations.
//  You can customize log level for a file using the ES_LOG_LEVEL macro,
//  or change the global default log level by defining the ES_LOG_LEVEL_DEFAULT macro.

#import <Foundation/Foundation.h>

#ifndef ES_LOG_LEVEL_DEFAULT
#ifdef DEBUG
#define ES_LOG_LEVEL_DEFAULT ES_LOG_LEVEL_DEBUG
#else
#define ES_LOG_LEVEL_DEFAULT ES_LOG_LEVEL_OFF
#endif
#endif

#ifndef ES_LOG_LEVEL
#define ES_LOG_LEVEL ES_LOG_LEVEL_DEFAULT
#endif

#define ES_LOG_LEVEL_OFF -1
#define ES_LOG_LEVEL_ERROR 0
#define ES_LOG_LEVEL_WARNING 1
#define ES_LOG_LEVEL_INFO 2
#define ES_LOG_LEVEL_DEBUG 3
#define ES_LOG_LEVEL_VERBOSE 4

#define ES_LOG_CURRENT_METHOD NSStringFromSelector(_cmd)

#define ESLog(level, frmt, ...) \
    [ESLog logWithLevel:level\
        currentLoglevel:ES_LOG_LEVEL\
                   file:__FILE__\
                   line:__LINE__\
                 format:frmt, ##__VA_ARGS__]

#define ESLoge(frmt, ...) ESLog(ES_LOG_LEVEL_ERROR, frmt, ##__VA_ARGS__)
#define ESLogw(frmt, ...) ESLog(ES_LOG_LEVEL_WARNING, frmt, ##__VA_ARGS__)
#define ESLogi(frmt, ...) ESLog(ES_LOG_LEVEL_INFO, frmt, ##__VA_ARGS__)
#define ESLogd(frmt, ...) ESLog(ES_LOG_LEVEL_DEBUG, frmt, ##__VA_ARGS__)
#define ESLogv(frmt, ...) ESLog(ES_LOG_LEVEL_VERBOSE, frmt, ##__VA_ARGS__)
#define ESLogt() ESLog(ES_LOG_LEVEL_DEBUG, @"%@", ES_LOG_CURRENT_METHOD)
#define ESLogtt() ESLog(ES_LOG_LEVEL_DEBUG, @"%@", [NSThread callStackSymbols])

@interface ESLog : NSObject

+ (void)logWithLevel:(int)level
     currentLoglevel:(int)currentLevel
                file:(const char*)file
                line:(uint)line
              format:(NSString *)format, ...;

@end
