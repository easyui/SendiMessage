//
//  AppDelegate_iPhone.h
//  SendiMessage
//
//  Created by Ouka on 12/1/13.
//  Copyright DinDin 2013. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AppDelegate_Shared.h"

@interface AppDelegate_iPhone : AppDelegate_Shared

@property (nonatomic, strong) NSDictionary * emojiDictionary;
@property (nonatomic, assign) UIBackgroundTaskIdentifier bgTask;
@property (nonatomic, assign) long int counter;


@end
