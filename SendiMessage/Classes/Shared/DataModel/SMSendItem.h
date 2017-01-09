//
//  SMSendItem.h
//  SendiMessage
//
//  Created by Ouka on 12/1/13.
//  Copyright (c) 2013 Ouka. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SMSendItem : NSObject

@property (nonatomic, copy) NSString * numberString;
@property (nonatomic, copy) NSString * idString;
@property (nonatomic, assign) int sendStatus;
@property (nonatomic, strong) NSDate * sendDate;

@end
