//
//  HKXSupplierReleasePartsViewController.h
//  HuiKuaiXiuPro
//
//  Created by 李金灿 on 2017/7/12.
//  Copyright © 2017年 Lee. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HKXSupplierReleasePartsModel.h"

@interface HKXSupplierReleasePartsViewController : UIViewController

@property (nonatomic , strong) HKXSupplierReleasePartsModel * partsInfoModel;//配件信息（为空时为发布新配件，不为空时为修改配件信息）
@property (nonatomic , assign) BOOL isEditable;//是否可编辑（true可编辑，FALSE不可编辑）

@end
