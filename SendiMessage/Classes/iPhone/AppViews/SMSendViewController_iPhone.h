//
//  SMSendViewController_iPhone.h
//  SendiMessage
//
//  Created by Ouka on 12/1/13.
//  Copyright (c) 2013 Ouka. All rights reserved.
//

#import "SMViewController_Shared.h"

@interface SMSendViewController_iPhone : SMViewController_Shared <UITableViewDataSource, UITableViewDelegate,
UIActionSheetDelegate>

@property (weak, nonatomic) IBOutlet UITableView *mainTableView;
@end
