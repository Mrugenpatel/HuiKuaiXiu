//
//  HKXOwnerRegisterMachineModel.h
//  HuiKuaiXiuPro
//
//  Created by 李金灿 on 2017/7/24.
//  Copyright © 2017年 Lee. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HKXOwnerRegisterMachineModel : NSObject<NSCoding>

@property (nonatomic , copy  ) NSString * uId;//用户id
@property (nonatomic , copy  ) NSString * nameplateNum;//整机名牌号
@property (nonatomic , copy  ) NSString * category;//设备类型（必填）
@property (nonatomic , copy  ) NSString * brand;//品牌
@property (nonatomic , copy  ) NSString * model;//型号
@property (nonatomic , copy  ) NSString * buyDate;//机器购买日期
@property (nonatomic , copy  ) NSString * address;//设备所在地
@property (nonatomic , copy  ) NSString * parameter;//关键所在地
@property (nonatomic , copy  ) NSString * remarks;//设备备注
@property (nonatomic , copy  ) NSString * picture;//设备图片(必填，多张图片用$隔开)


+ (instancetype)getUserModel;

@end
