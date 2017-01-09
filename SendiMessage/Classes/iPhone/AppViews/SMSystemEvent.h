//
//  SMSystemEvent.h
//  SendiMessage
//
//  Created by Ouka on 12/4/13.
//  Copyright (c) 2013 Ouka. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SMSystemEvent : NSObject

+ (void)systemSendMessageWithNumber:(NSString *)number message:(NSString *)message;

+ (NSString *)randomEmotion;

@end
