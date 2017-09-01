//
//  HKXRepairMapViewController.h
//  HuiKuaiXiuPro
//
//  Created by 李金灿 on 2017/7/18.
//  Copyright © 2017年 Lee. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HKXRepairMapViewController : UIViewController

@property (nonatomic , assign)BOOL isReceived;//是否有师傅接单

@property (nonatomic , copy)NSString *address;//上页面传来的地址

@property (nonatomic , copy)NSString *ruoId;//生成的订单ID

@end
