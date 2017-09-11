//
//  maintainerModel.h
//  HuiKuaiXiuPro
//
//  Created by daemona on 2017/8/1.
//  Copyright © 2017年 Lee. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface repairListModel : NSObject


//repairId	Long	报修单Id
@property (nonatomic, assign) NSNumber * repairId;
//brandModel	String	品牌型号
@property (nonatomic, copy) NSString * brandModel;
//mId	Long	设备id
@property (nonatomic, assign) NSNumber * mId;
//address	String	设备所在地
@property (nonatomic, copy) NSString * address;
//longitude	String	经度
@property (nonatomic, copy) NSString * longitude;
//latitude	String	纬度
@property (nonatomic, copy) NSString * latitude;
//contact	String	联系人
@property (nonatomic, copy) NSString * contact;
//telephone	String	联系电话
@property (nonatomic, copy) NSString * telephone;
//workHours	String	设备工作时长
@property (nonatomic, copy) NSString * workHours;
//fault	String	故障类型
@property (nonatomic, copy) NSString * fault;
//faultInfo	String	故障描述
@property (nonatomic, copy) NSString * faultInfo;
//picture	List<String>	图片
@property (nonatomic, strong) NSMutableArray * picture;
//appointmentTime	Date	预约时间
@property (nonatomic, copy) NSString * appointmentTime;
//repairStatus	Integer	维修状态 0 可以接单
@property (nonatomic, assign) NSNumber *  repairStatus;
//repairexplain		状态说明
@property (nonatomic, copy) NSString * repairexplain;
//uId	Long	报修人Id
@property (nonatomic, assign) NSNumber *  uId;
//createDate	Date	订单报修时间
@property (nonatomic, copy) NSString * createDate;
//updateDate	Date	订单开始维修时间
@property (nonatomic, strong) NSDate * updateDate;
//remarks	String	订单备注
@property (nonatomic, copy) NSString * remarks;

- (instancetype)initWithDict:(NSDictionary *)dic;
+ (instancetype)ordersWithDict:(NSDictionary *)dict;
+ (NSMutableArray *)ordersWithArray:(NSArray *)array;
@end
