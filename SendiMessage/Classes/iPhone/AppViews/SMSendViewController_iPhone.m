//
//  SMSendViewController_iPhone.m
//  SendiMessage
//
//  Created by Ouka on 12/1/13.
//  Copyright (c) 2013 Ouka. All rights reserved.
//

#import "SMSendViewController_iPhone.h"
#import "SMCell_iPhone.h"
#import "SMSendInfo.h"
#import "SMSendItem.h"
#import "SMSendStatus.h"
#import "SMSystemEvent.h"
#import "SMSSHTools.h"
#import "FMDatabase.h"
#import "CMOpenALSoundManager.h"

#define MaxRetryCount   10000
#define NotStatus       9999

@interface SMSendViewController_iPhone ()

@property (nonatomic, assign) int               sendIndex;
@property (nonatomic, strong) SMSendInfo        *sendInfo;
@property (nonatomic, strong) SMSendStatus      *sendStatus;
@property (nonatomic, assign) int               checkSendTaskTimes;
@property (nonatomic, assign) int               checkReportTaskTimes;
@property (nonatomic, assign) int               messageNumber;
@property (nonatomic, strong) NSMutableArray    *tableDisplayArray;
@property (nonatomic, assign) int               hasSendTotalCount;

@property (nonatomic, strong) NSMutableDictionary   *phoneNumIdDic;
@property (nonatomic, strong) NSMutableArray        *sendItemArr;

@property (nonatomic, strong) CMOpenALSoundManager *soundMgr;

- (void)showManualHandleSheet;

@end

@implementation SMSendViewController_iPhone

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];

    if (self) {
        // Custom initialization
    }

    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.

    self.soundMgr = [[CMOpenALSoundManager alloc] init];

    [self initUI];

    [self checkSendTask];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload
{
    [self setMainTableView:nil];
    [super viewDidUnload];
}

// 407596111
// 2017256708

#pragma mark - Public methods

- (void)initUI
{
    [self.mainTableView registerNib:[UINib nibWithNibName:@"SMCell_iPhone" bundle:nil] forCellReuseIdentifier:@"SMCell_iPhone"];
}

#pragma mark - Private methods

- (void)addHeaderWithMessage:(NSString *)message
{
    UITextView *header = [[UITextView alloc] initWithFrame:CGRectMake(0, 0, 320, 120)];

    header.editable = NO;
    header.text = message;
    header.textColor = [UIColor blueColor];
    header.font = [UIFont systemFontOfSize:15];
    self.mainTableView.tableHeaderView = header;
}

- (void)startSendMessageTask
{
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(sendMessage) object:nil];

    DebugLog(@"--startSendMessageTask--");

    /*
     *   NSString *sendAccount = [SMConfigManager sharedManager].configItem.checkNumberString;
     *   if (sendAccount.length > 0) {
     *    [SMSystemEvent systemSendMessageWithNumber:sendAccount message:self.sendInfo.messageString];
     *
     *    if ([sendAccount rangeOfString:@"@"].length == 0) {
     *        sendAccount = [NSString stringWithFormat:@"+86%@", sendAccount];
     *    }
     *
     *    while (YES) {
     *
     *        DebugLog(@"--check Monitor number--");
     *
     *        FMResultSet *rs = [AppSharedDelegate.db executeQuery:@"select message.is_sent  sendStatus,handle.id numberString from message,handle where handle.rowid = message.handle_id  and handle.id = ?", sendAccount];
     *        int         sendStatus = NotStatus; //
     *
     *        DebugLog(@"--FMResultSet %@",rs);
     *
     *        while ([rs next]) {
     *             sendStatus = [rs intForColumn:@"sendStatus"];
     *
     *            DebugLog(@"--while sendStatus :%d",sendStatus);
     *
     *            if (sendStatus == 0) {
     *                [self showManualHandleSheet];
     *                [rs close];
     *                return;
     *            }
     *        }
     *
     *        [rs close];
     *
     *        if (sendStatus == 1) {
     *            break;
     *        }
     *
     *        DebugLog(@"--sleep sendStatus :%d",sendStatus);
     *
     *        [NSThread sleepForTimeInterval:1];    // 休息一秒
     *    }
     *   }
     */
    DebugLog(@"--Over check Monitor number--");
    NSString *sendAccount = [SMConfigManager sharedManager].configItem.checkNumberString;

    if (sendAccount.length > 0) {
        [SMSystemEvent systemSendMessageWithNumber:sendAccount message:self.sendInfo.messageString];
    }

    int count = [self.sendInfo.sendItemArray count];
    self.hasSendTotalCount += count;

    [self.sendItemArr removeAllObjects];
    [self.phoneNumIdDic removeAllObjects];
    self.phoneNumIdDic = [[NSMutableDictionary alloc] initWithCapacity:count];
    self.sendItemArr = [[NSMutableArray alloc]initWithCapacity:count];

    self.messageNumber = 0;
    [self addHeaderWithMessage:self.sendInfo.messageString];
    self.tableDisplayArray = [NSMutableArray array];
    [self.mainTableView reloadData];

    [self sendMessage];
}

- (void)sendMessage
{
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(sendMessage) object:nil];

    NSArray *sendItemArray = self.sendInfo.sendItemArray;

    if (self.messageNumber >= [sendItemArray count]) {
        // report

        [self checkReportTask];

        return;
    }

    SMSendItem *item = [sendItemArray safeObjectAtIndex:self.messageNumber];
    item.sendDate = [NSDate date];
    [self.tableDisplayArray insertObject:item atIndex:0];
    [self.mainTableView reloadData];

    [self.phoneNumIdDic setValue:item.idString forKey:item.numberString];

    [SMSystemEvent systemSendMessageWithNumber:item.numberString message:self.sendInfo.messageString];

    [self performSelector:@selector(sendMessage) withObject:nil afterDelay:self.sendInfo.sendInterval];

    self.messageNumber++;
}

- (void)checkSendTask
{
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(checkSendTask) object:nil];

    [[SMShareDataManager sharedManager] sendiMessageWithObserver:self];
}

- (void)checkReportTask
{
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(checkReportTask) object:nil];

    NSString *sendAccount = [SMConfigManager sharedManager].configItem.checkNumberString;

    if (sendAccount.length > 0) {
        if ([sendAccount rangeOfString:@"@"].length == 0) {
            sendAccount = [NSString stringWithFormat:@"+86%@", sendAccount];
        }

        DebugLog(@"--check Monitor number--");

        FMResultSet *rs = [AppSharedDelegate.db executeQuery:@"select message.is_sent  sendStatus,handle.id numberString from message,handle where handle.rowid = message.handle_id  and handle.id = ?", sendAccount];
        int         sendStatus = NotStatus; //

        DebugLog(@"--FMResultSet %@", rs);

        while ([rs next]) {
            sendStatus = [rs intForColumn:@"sendStatus"];

            DebugLog(@"--while sendStatus :%d", sendStatus);

            if (sendStatus == 0) {
                [self showManualHandleSheet];
                [rs close];
                return;
            }
        }

        [rs close];

        DebugLog(@"--sleep sendStatus :%d", sendStatus);
    }

    FMResultSet *rs = [AppSharedDelegate.db executeQuery:@"select max(rowid) maxRowid from message"];
    int         max = 0;
    int         min = 0;

    while ([rs next]) {
        max = [rs intForColumn:@"maxRowid"];
        min = max - self.messageNumber + 1;
    }

    [rs close];

    rs = [AppSharedDelegate.db executeQuery:@"select message.is_sent  sendStatus,handle.id numberString from message,handle where handle.rowid = message.handle_id  and message.rowid >=? and message.rowid <= ?", [NSNumber numberWithInt:min], [NSNumber numberWithInt:max]];

    while ([rs next]) {
        @autoreleasepool {
            NSString    *numberString = [[rs stringForColumn:@"numberString"] substringWithRange:NSMakeRange(3, 11)];
            NSString    *idStr = [self.phoneNumIdDic objectForKey:numberString];
            int         sendStatus = [rs intForColumn:@"sendStatus"];
            [self.sendItemArr addObject:@{@"id":idStr, @"status":@(sendStatus)}];
        }
    }

    [rs close];

    id jsonData = [self JSONValue:self.sendItemArr];
    [[SMShareDataManager sharedManager] sendReportWithIsRestart:[self needRestart]
                                        sendItemArray   :jsonData
                                        scanType        :self.sendInfo.scanType
                                        isLastItem      :self.sendInfo.isLastItem
                                        Observer        :self];
}

- (void)prepareToResetDevice
{
    /*
     *   1.delete db files
     *   2.modify macaddress
     *   3.reboot
     */

    // delete db files

    /*
     *   NSString        *path = @"/var/mobile/Library/SMS";
     *   NSFileManager   *manager = [NSFileManager defaultManager];
     *   NSError         *error = nil;
     *
     *   if ([manager contentsOfDirectoryAtPath:path error:&error]) {
     *    [manager removeItemAtPath:@"/var/mobile/Library/SMS/sms.db" error:&error];
     *
     *    if (error) {
     *        NSLog(@"f");
     *    } else {
     *        NSLog(@"s");
     *    }
     *   } else {
     *    NSLog(@"/var/mobile/Library/SMS不存在");
     *   }
     */
    [AppSharedDelegate.db beginTransaction];

    [AppSharedDelegate.db executeUpdate:@"DROP TRIGGER delete_attachment_files"];
    [AppSharedDelegate.db executeUpdate:@"delete from chat_message_join"];
    [AppSharedDelegate.db executeUpdate:@"delete from chat_handle_join"];
    [AppSharedDelegate.db executeUpdate:@"delete from handle"];
    [AppSharedDelegate.db executeUpdate:@"delete from chat"];
    [AppSharedDelegate.db executeUpdate:@"delete from message"];

    [AppSharedDelegate.db commit];

    // modify macaddress
    [SMSSHTools modifyMacAddress];

    // delay to reboot
    [self performSelector:@selector(delayToRebootDevice) withObject:nil afterDelay:5];
}

- (void)delayToRebootDevice
{
    [SMSSHTools rebootDevice];
}

- (BOOL)needRestart
{
    return self.hasSendTotalCount >= [SMConfigManager sharedManager].configItem.countToRestart;
}

- (id)JSONValue:(id)data
{
    NSError *error = nil;
    NSData  *jsonData = [NSJSONSerialization    dataWithJSONObject:data
                                                options :NSJSONWritingPrettyPrinted
                                                error   :&error];

    if (([jsonData length] > 0) && (error == nil)) {
        return jsonData;
    } else {
        return nil;
    }
}

- (void)showManualHandleSheet
{
    [self.soundMgr playBackgroundMusic:@"warning1.wav"];

    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"人工处理"
                                                        delegate                :self
                                                        cancelButtonTitle       :nil
                                                        destructiveButtonTitle  :nil
                                                        otherButtonTitles       :@"删除并启动", @"人工处理，软件停止工作", @"重置", nil];
    [actionSheet showInView:self.view];
}

#pragma mark - UITableViewDelegate methods

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.tableDisplayArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SMCell_iPhone *cell = [tableView dequeueReusableCellWithIdentifier:@"SMCell_iPhone"];

    SMSendItem *item = [self.tableDisplayArray objectAtIndex:indexPath.row];

    cell.phoneLabel.text = item.numberString;
    cell.dateLabel.text = [item.sendDate dateToDateStringWithDateFormat:@"yyyy/MM/dd HH:mm:ss" timezone:@"GMT+0800"];

    return cell;
}

#pragma mark - NLDataRequestProtocol methods

- (void)requestFetchSucceeded:(NLPackage *)package
{
    if ([package.requestGroupName isEqualToString:SendMessage]) {
        self.checkSendTaskTimes = 0;

        self.sendInfo = [package.responseDataArray lastObject];

        NSError         *err = nil;
        NSDictionary    *dic = [NSJSONSerialization JSONObjectWithData:package.responseDataBuffer
            options :0
            error   :&err];
        NSString *string = [dic objectForKey:@"content"];

        if (string && [string isKindOfClass:[NSString class]]) {
            self.sendInfo.messageString = [string URLDecodedString];
        } else {
            self.sendInfo.messageString = nil;
        }

        if ([self.sendInfo.sendItemArray count] > 0) {
            [self startSendMessageTask];
        } else {
            [self performSelector:@selector(checkSendTask) withObject:nil afterDelay:[SMConfigManager sharedManager].configItem.delayToScan];
        }
    } else if ([package.requestGroupName isEqualToString:SendStatus]) {
        self.checkReportTaskTimes = 0;

        self.sendStatus = [package.responseDataArray lastObject];

        if (self.sendStatus.status) {
            [self addHeaderWithMessage:nil];
            self.tableDisplayArray = nil;
            [self.mainTableView reloadData];

            if ([self needRestart]) {
                [self prepareToResetDevice];
            } else {
                [self performSelector:@selector(checkSendTask) withObject:nil afterDelay:[SMConfigManager sharedManager].configItem.delayToScan];
            }
        } else {
            [self performSelector:@selector(checkReportTask) withObject:nil afterDelay:[SMConfigManager sharedManager].configItem.delayToScan];
        }
    }
}

- (void)requestFetchError:(NLPackage *)package
{
    if ([package.requestGroupName isEqualToString:SendMessage]) {
        if (self.checkSendTaskTimes < MaxRetryCount) {
            self.checkSendTaskTimes++;

            [self performSelector:@selector(checkSendTask) withObject:nil afterDelay:[SMConfigManager sharedManager].configItem.delayToScan];
        } else {
            NSString    *title = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleDisplayName"];
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:title
                message             :@"网络错误！"
                delegate            :self
                cancelButtonTitle   :@"取消"
                otherButtonTitles   :@"重试", nil];
            alertView.tag = 100;
            [alertView show];
        }
    } else if ([package.requestGroupName isEqualToString:SendStatus]) {
        if (self.checkReportTaskTimes < MaxRetryCount) {
            self.checkReportTaskTimes++;

            [self performSelector:@selector(checkReportTask) withObject:nil afterDelay:[SMConfigManager sharedManager].configItem.delayToScan];
        } else {
            NSString    *title = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleDisplayName"];
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:title
                message             :@"网络错误！"
                delegate            :self
                cancelButtonTitle   :@"取消"
                otherButtonTitles   :@"重试", nil];
            alertView.tag = 101;
            [alertView show];
        }
    }
}

#pragma mark - UIAlertViewDelegate methods

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 100) {
        if (1 == buttonIndex) {
            [self checkSendTask];
        }
    } else if (alertView.tag == 101) {
        if (1 == buttonIndex) {
            [self checkReportTask];
        }
    } else if (alertView.tag == 10000) {
        [self prepareToResetDevice];
    }
}

#pragma mark - UIActionSheetDelegate methods
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    [self.soundMgr stopBackgroundMusic];

    if (0 == buttonIndex) {
        // @"删除并启动"
        [self prepareToResetDevice];
    } else if (1 == buttonIndex) {
        // @"人工处理，软件停止工作"
        exit(0);
    } else if (2 == buttonIndex) {
        // @"重置"
        [self checkSendTask];
    }
}

@end
