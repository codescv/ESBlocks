//
//  ESMacros.h
//  ESBlocks
//
//  Created by Chi Zhang on 7/25/12.
//  Copyright (c) 2012 Chi Zhang. All rights reserved.
//

#define ES_IS_EMPTY_STRING(X) (X == nil || [X isEqualToString:@""])

#define ES_BOOL_OBJ(X) [NSNumber numberWithBool:X]
#define ES_INT_OBJ(X) [NSNumber numberWithInt:X]
#define ES_UINT_OBJ(X) [NSNumber numberWithUnsignedInt:X]
#define ES_FLOAT_OBJ(X) [NSNumber numberWithFloat:X]