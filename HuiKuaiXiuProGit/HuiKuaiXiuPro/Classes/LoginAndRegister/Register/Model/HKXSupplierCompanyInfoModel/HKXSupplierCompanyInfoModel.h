//
//  HKXSupplierCompanyInfoModel.h
//  HuiKuaiXiuPro
//
//  Created by 李金灿 on 2017/7/25.
//  Copyright © 2017年 Lee. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HKXSupplierCompanyInfoModel : NSObject<NSCoding>

@property (nonatomic , copy  ) NSString * uId;//用户id
@property (nonatomic , copy  ) NSString * role;//角色类型
@property (nonatomic , copy  ) NSString * realName;//联系人（头像）
@property (nonatomic , copy  ) NSString * companyName;//公司名
@property (nonatomic , copy  ) NSString * companyAddress;//公司所在地
@property (nonatomic , copy  ) NSString * registerCapital;//注册资金
@property (nonatomic , copy  ) NSString * establishmentTime;//公司成立时间
@property (nonatomic , copy  ) NSString * companyIntroduce;//公司介绍
@property (nonatomic , copy  ) NSString * companyMain;//公司主管


+ (instancetype)getUserModel;

@end
