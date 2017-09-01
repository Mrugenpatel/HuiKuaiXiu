//
//  HKXMineAddNewReceiveAddressViewController.h
//  HuiKuaiXiuPro
//
//  Created by 李金灿 on 2017/8/24.
//  Copyright © 2017年 Lee. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HKXMineAddressListData.h"

@interface HKXMineAddNewReceiveAddressViewController : UIViewController

@property (nonatomic , assign )BOOL isNew;//是否为新增地址（true为新，FALSE为修改）
@property (nonatomic , strong) HKXMineAddressListData * addressData;//地址model

@end
