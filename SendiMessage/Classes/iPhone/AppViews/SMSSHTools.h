//
//  SMSSHTools.h
//  SendiMessage
//
//  Created by Ouka on 12/5/13.
//  Copyright (c) 2013 Ouka. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SMSSHTools : NSObject

+ (void)rebootDevice;

+ (void)modifyMacAddress;

+ (NSString*) generateRandomMAC;

@end
