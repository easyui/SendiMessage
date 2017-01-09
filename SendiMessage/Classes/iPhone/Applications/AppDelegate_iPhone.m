//
//  AppDelegate_iPhone.m
//  SendiMessage
//
//  Created by Ouka on 12/1/13.
//  Copyright DinDin 2013. All rights reserved.
//

#import "AppDelegate_iPhone.h"

@interface AppDelegate_iPhone ()

@end


@implementation AppDelegate_iPhone

- (void)dealloc
{

}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
     
    if ([super application:application didFinishLaunchingWithOptions:launchOptions]) {

        [self initDatabase];

        
        NSString *path = [[NSBundle mainBundle] bundlePath];
        NSString *finalPath = [path stringByAppendingPathComponent:@"EmojiList.plist"];
        self.emojiDictionary = [NSDictionary dictionaryWithContentsOfFile:finalPath];
        
        //[self initMainViewWithApplication:application didFinishLaunchingWithOptions:launchOptions];
        

        [self.window makeKeyAndVisible];
        
        return YES;
    }
    
    return NO;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    [super applicationWillResignActive:application];
    
}

- (void)backgroundHandler
{
    NSLog(@"### -->backgroundinghandler");

    self.bgTask = [[UIApplication sharedApplication] beginBackgroundTaskWithExpirationHandler:^{
        [[UIApplication sharedApplication] endBackgroundTask:self.bgTask];
        self.bgTask = UIBackgroundTaskInvalid;
    }];
    
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    [super applicationDidEnterBackground:application];
    
    BOOL backgroundAccepted = [[UIApplication sharedApplication] setKeepAliveTimeout:24*3600*365*10 handler:^{
        [self backgroundHandler];
    }];
    
    if (backgroundAccepted){
        NSLog(@"backgrounding accepted");
    }
    
    [self backgroundHandler];
    
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    [super applicationWillEnterForeground:application];
    
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    [super applicationDidBecomeActive:application];
    
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    [super applicationWillTerminate:application];
    
}


#pragma mark - Public methods

- (void)initMainViewWithApplication:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [super initMainViewWithApplication:application didFinishLaunchingWithOptions:launchOptions];
    
}



#pragma mark - Private methods



@end
