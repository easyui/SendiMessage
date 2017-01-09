//
//  SMSystemEvent.m
//  SendiMessage
//
//  Created by Ouka on 12/4/13.
//  Copyright (c) 2013 Ouka. All rights reserved.
//

#import "SMSystemEvent.h"
#import "AppDelegate_iPhone.h"

@implementation SMSystemEvent

+ (void)systemSendMessageWithNumber:(NSString *)number message:(NSString *)message
{
    NSString * sendMessage = [SMSystemEvent addRandomEmoticonForMessage:message];
    NSString * sendString = [NSString stringWithFormat:@"/Applications/biteSMS.app/biteSMS -send -iMessage \"%@\" \"%@\"",number,sendMessage];
    
    DebugLog(@"--systemSendMessageWithNumber:%@--message:%@",number,message);
    DebugLog(@"--------------------------%s--------------",[sendString cStringUsingEncoding:NSUTF8StringEncoding]);
    
    system([sendString cStringUsingEncoding:NSUTF8StringEncoding]);
}

+ (NSString *)addRandomEmoticonForMessage:(NSString *)message
{    
    NSString * randomEmotion = [SMSystemEvent randomEmotion];
    
    return [message stringByReplacingOccurrencesOfString:@"<dd_emo>emoji</dd_emo>" withString:randomEmotion];
}

+ (NSString *)randomEmotion
{
    NSDictionary *dict = [(AppDelegate_iPhone *)AppSharedDelegate emojiDictionary];
    
    int randomIndex = arc4random()%[dict.allKeys count];
    NSString * key = [dict.allKeys safeObjectAtIndex:randomIndex];
    
    return [dict objectForKey:key];
}

@end
