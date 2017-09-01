//
//  CompanyModel.h
//  HuiKuaiXiuPro
//
//  Created by daemona on 2017/8/31.
//  Copyright © 2017年 Lee. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CompanyModel : NSObject

//手机号
@property(nonatomic ,copy)NSString *username;

//角色
@property(nonatomic ,copy)NSString *role;

//联系人姓名
@property(nonatomic ,copy)NSString *realName;

//地址
@property(nonatomic ,copy)NSString *address;

//公司名称
@property(nonatomic ,copy)NSString *companyName;

//头像
@property(nonatomic ,copy)NSString *photo;

//邀请码
@property(nonatomic ,copy)NSString *inviteCode;


//推荐码
@property(nonatomic ,copy)NSString *recommendCode;

//是否完善资料
@property(nonatomic ,copy)NSString *perfectInfo;


//注册资金
@property(nonatomic ,copy)NSString *registerCapital;

//公司成立时间
@property(nonatomic ,copy)NSString *establishmentTime;

//公司介绍
@property(nonatomic ,copy)NSString *companyIntroduce;

//公司主营
@property(nonatomic ,copy)NSString *companyMain;

- (instancetype)initWithDict:(NSDictionary *)dict;

@end
