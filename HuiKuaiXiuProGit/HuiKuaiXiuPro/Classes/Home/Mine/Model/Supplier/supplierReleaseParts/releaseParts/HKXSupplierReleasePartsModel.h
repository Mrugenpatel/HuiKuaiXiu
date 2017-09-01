//
//  HKXSupplierReleasePartsModel.h
//  HuiKuaiXiuPro
//
//  Created by 李金灿 on 2017/7/27.
//  Copyright © 2017年 Lee. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HKXSupplierReleasePartsModel : NSObject<NSCoding>

@property (nonatomic , copy  ) NSString * pid;//配件主键

@property (nonatomic , copy  ) NSString * mid;//用户id
@property (nonatomic , copy  ) NSString * number;//配件编号
@property (nonatomic , copy  ) NSString * brand;//配件品牌
@property (nonatomic , copy  ) NSString * basename;//配件名称
@property (nonatomic , copy  ) NSString * model;//型号
@property (nonatomic , copy  ) NSString * tempPrice;//价格
@property (nonatomic , copy  ) NSString * introduct;//产品描述
@property (nonatomic , copy  ) NSString * picture;//图片
@property (nonatomic , copy  ) NSString * category;//类别
@property (nonatomic , copy  ) NSString * applyCareModel;//适用车型
@property (nonatomic , copy  ) NSString * stock;//库存



+ (instancetype)getUserModel;

@end
