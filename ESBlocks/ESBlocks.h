//
//  ESBlocks.h
//  ESBlocks
//
//  Created by Chi Zhang on 8/6/11.
//  Copyright 2011 Chi Zhang. All rights reserved.
//

// Block typedefs
typedef void (^VoidBlock)();
typedef void (^AlertDismissBlock)(UIAlertView *av, int buttonIndex);
typedef void (^ActionSheetDismissBlock)(UIActionSheet *as, int buttonIndex);
typedef void (^NotificationCallbackBlock)(NSNotification *notif);

#import "ESUtils.h"
#import "ESAdditions.h"
#import "ESUI.h"
