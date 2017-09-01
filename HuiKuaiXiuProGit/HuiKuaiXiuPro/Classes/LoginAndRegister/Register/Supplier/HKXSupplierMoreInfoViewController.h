//
//  HKXSupplierMoreInfoViewController.h
//  HuiKuaiXiuPro
//
//  Created by 李金灿 on 2017/7/5.
//  Copyright © 2017年 Lee. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HKXRegisterData.h"

@interface HKXSupplierMoreInfoViewController : UIViewController

@property (nonatomic , strong) HKXRegisterData * userRegisterData;//用户注册时返回信息

@property (nonatomic , copy) NSString * contactName;//联系人
@property (nonatomic , copy) NSString * phone;//电话
@property (nonatomic , copy) NSString * companyName;//公司名称
@property (nonatomic , copy) NSString * companyCity;//公司所在城市

@end
