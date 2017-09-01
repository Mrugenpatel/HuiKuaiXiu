//
//  HKXRegisterBasicInfoModel.h
//  HuiKuaiXiuPro
//
//  Created by 李金灿 on 2017/7/4.
//  Copyright © 2017年 Lee. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HKXRegisterBasicInfoModel : NSObject<NSCoding>

@property (nonatomic , copy  ) NSString * userId;//用户id
@property (nonatomic , copy  ) NSString * realName;//联系人
@property (nonatomic , copy  ) NSString * address;//地址
@property (nonatomic , copy  ) NSString * companyName;//公司名称
@property (nonatomic , copy  ) NSString * inviteCode;//推荐码


+ (instancetype)getUserModel;

@end
