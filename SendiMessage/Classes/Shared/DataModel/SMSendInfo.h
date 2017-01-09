//
//  SMSendInfo.h
//  SendiMessage
//
//  Created by Ouka on 12/1/13.
//  Copyright (c) 2013 Ouka. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SMSendInfo : NSObject

@property (nonatomic, assign) int scanType;
@property (nonatomic, copy) NSString * messageString;
@property (nonatomic, assign) int sendInterval;
@property (nonatomic, assign) BOOL isLastItem;
@property (nonatomic, strong) NSArray * sendItemArray;

@end
