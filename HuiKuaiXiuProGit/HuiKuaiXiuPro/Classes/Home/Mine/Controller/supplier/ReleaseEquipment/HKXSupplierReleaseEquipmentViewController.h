//
//  HKXSupplierReleaseEquipmentViewController.h
//  HuiKuaiXiuPro
//
//  Created by 李金灿 on 2017/7/12.
//  Copyright © 2017年 Lee. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HKXSupplierEquipmentManagementModelDataModels.h"

@interface HKXSupplierReleaseEquipmentViewController : UIViewController

@property (nonatomic , strong) HKXSupplierEquipmentManagementData * equipmentModel;

@property (nonatomic , assign) BOOL isEditable;//是否可编辑（true可编辑，FALSE不可编辑）

@end
