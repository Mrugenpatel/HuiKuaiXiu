//
//  HKXBasicInfoRegisterViewController.h
//  HuiKuaiXiuPro
//
//  Created by 李金灿 on 2017/7/3.
//  Copyright © 2017年 Lee. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HKXRegisterData.h"

@interface HKXBasicInfoRegisterViewController : UIViewController

@property (nonatomic , copy) NSString * userMobile;//用户手机号
@property (nonatomic , strong) HKXRegisterData * userRegisterData;//用户注册时返回信息

@end
