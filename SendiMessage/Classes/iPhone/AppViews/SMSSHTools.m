//
//  SMSSHTools.m
//  SendiMessage
//
//  Created by Ouka on 12/5/13.
//  Copyright (c) 2013 Ouka. All rights reserved.
//

#import "SMSSHTools.h"
#import <NMSSH/NMSSH.h>

@implementation SMSSHTools

+ (void)rebootDevice
{
    NMSSHSession *session = [NMSSHSession connectToHost:@"127.0.0.1:22"
                                           withUsername:@"root"];
    
    if (session.isConnected) {
        
        [session authenticateByPassword:@"alpine"];
        
        if (session.isAuthorized) {
            
        }
    }else {
        
    }
    
    NSError *error = nil;
    
    [session.channel execute:@"reboot" error:&error];
    
    NSLog(@"------------- reboot");
    
    [session disconnect];
}

+ (void)modifyMacAddress
{
    NMSSHSession *session = [NMSSHSession connectToHost:@"127.0.0.1:22"
                                           withUsername:@"root"];
    
    if (session.isConnected) {
        
        [session authenticateByPassword:@"alpine"];
        
        if (session.isAuthorized) {
            
        }
    }else {
        
    }
    
    NSError *error = nil;
    
    NSString * executeString = [NSString stringWithFormat:@"nvram wifiaddr=%@",[SMSSHTools generateRandomMAC]];
    
    [session.channel execute:executeString error:&error];
    
    NSLog(@"------------- %@",executeString);
    
    [session disconnect];
}

+ (NSString*) generateRandomMAC {
    // We will perform this with an Array that holds the HEX values
    NSMutableArray *components = [NSMutableArray array];
    // Six times we will add something to the Array
    for (NSInteger i = 0; i < 6; i++) {
        // Each time we add two random HEX values combined in one NSString. E.g. "AF" or "5C"
        NSString *component = [[NSString alloc] initWithFormat:@"%1X%1X", arc4random() % 15, arc4random() % 15];
        // Please in lower case
        [components addObject:[component lowercaseString]];
    }
    // Put it all together by joining the six components with colons
    return [[components componentsJoinedByString:@":"] uppercaseString];
}

@end
