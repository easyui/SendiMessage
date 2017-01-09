/*
 Ouka project definition file
 */

//=============================== Project Information =============================

#define VERSION_ID [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleVersion"]
#define Ouka_URL @"http://www.Ouka.com"


//=============================== Shared Definition ===============================

#define DEBUG_MODE  0
#define USE_LOCAL_CONFIG 0

#define DebugLog( s, ... ) if([[SMConfigManager sharedManager].configItem.logging isEqualToString:@"true"]) NSLog( @"<%p %@:(%d)> %@", self, [[NSString stringWithUTF8String:__FILE__] lastPathComponent], __LINE__, [NSString stringWithFormat:(s), ##__VA_ARGS__] )

#define ShareDataNotification(groupName) [SMShareDataManager dataCallbackNotificationNameWithDataGroupName:groupName]


//=============================== Project Definition ===============================

#define AppSharedDelegate   ((AppDelegate_Shared *)[UIApplication sharedApplication].delegate)


//------------------------------- Request Parameters -------------------------------

#define ConfigURL              @"http://ipodapp.dindin.com.cn/config_touch.xml"

#define ConfigurationGroupName          @"ConfigurationFetch"
#define SendMessage                     @"SendMessage"
#define SendStatus                      @"SendStatus"


//------------------------------- Notification --------------------------------------

//start page
#define StartInitMainViewNotification                        @"StartInitMainViewNotification"

//User Default Function and Notification
#define AppChangeTimeZoneNotification                        @"AppChangeTimeZoneNotification"
#define AppScoreSwitchNotification                           @"AppScoreSwitchNotification"


//------------------------------- UserDefault ---------------------------------------

#define ServerURLKey                                                @"serverURL"


//------------------------------- Constant ------------------------------------------



//------------------------------- Other ---------------------------------------------



//------------------------------- Enum ----------------------------------------------





