//
//  EquipmentGoodsModel.h
//  HuiKuaiXiuPro
//
//  Created by daemona on 2017/8/31.
//  Copyright © 2017年 Lee. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface EquipmentGoodsModel : NSObject

//主键ID
@property(nonatomic ,copy)NSString *pmaId;

//会员id
@property(nonatomic ,copy)NSString *mId;

//图片
@property(nonatomic ,copy)NSString *picture;

//类型
@property(nonatomic ,copy)NSString *type;

//品牌
@property(nonatomic ,copy)NSString *brand;

//型号
@property(nonatomic ,copy)NSString *modelnum;

//关键参数
@property(nonatomic ,copy)NSString *parameter;

//企业名称
@property(nonatomic ,copy)NSString *compname;

//描述
@property(nonatomic ,copy)NSString *bewrite;

//配件地址
@property(nonatomic ,copy)NSString *address;



- (instancetype)initWithDict:(NSDictionary *)dict;


@end
