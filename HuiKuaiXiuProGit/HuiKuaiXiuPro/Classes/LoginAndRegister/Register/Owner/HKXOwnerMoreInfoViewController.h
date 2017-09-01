//
//  HKXOwnerMoreInfoViewController.h
//  HuiKuaiXiuPro
//
//  Created by 李金灿 on 2017/7/3.
//  Copyright © 2017年 Lee. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HKXRegisterData.h"


@interface HKXOwnerMoreInfoViewController : UIViewController

@property (nonatomic , copy) NSString * mark;//新注册用户添加设备还是报修添加设备

@property (nonatomic , strong) HKXRegisterData * userRegisterData;//用户注册时返回信息

@end
