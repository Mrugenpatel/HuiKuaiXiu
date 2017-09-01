//
//  HKXMineOwnerRepairDetailViewController.h
//  HuiKuaiXiuPro
//
//  Created by 李金灿 on 2017/8/11.
//  Copyright © 2017年 Lee. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HKXMineServerOrderListData.h"//维修师傅的订单model

@interface HKXMineOwnerRepairDetailViewController : UIViewController

@property (nonatomic , copy) NSString * repairId;//报修单id
@property (nonatomic , assign) BOOL isOwner;//true为机主，FALSE为维修师傅
@property (nonatomic , strong) HKXMineServerOrderListData * orderData;//维修师傅的订单详情

@end
