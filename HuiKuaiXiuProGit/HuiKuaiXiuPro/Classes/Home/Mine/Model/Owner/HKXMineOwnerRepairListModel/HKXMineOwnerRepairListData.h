//
//  HKXMineOwnerRepairListData.h
//
//  Created by   on 2017/8/9
//  Copyright (c) 2017 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>



@interface HKXMineOwnerRepairListData : NSObject <NSCoding, NSCopying>

@property (nonatomic, assign) double repairId;//报修单id
@property (nonatomic, assign) double uId;//报修人id
@property (nonatomic, copy  ) NSString *fault;//故障类型
@property (nonatomic, copy  ) NSString *workHours;//设备工作时长
@property (nonatomic, copy  ) NSString *repairexplain;//状态说明
@property (nonatomic, copy  ) NSString *contact;//联系人
@property (nonatomic, copy  ) NSString *faultInfo;//故障描述
@property (nonatomic, assign) int       repairStatus;//维修状态(当repairStatus 为2时跳转接单师傅列表，根据repairexplain字段判断是否跳转至地图界面或接单师傅列表界面;当 repairStatus 为 3或 4 待付款不可点击;当 repairStatus 为5 时待付款可点击;当 repairStatus 为 0 时 已完成;当repairStatus 为-1 时 已取消 )
@property (nonatomic, copy  ) NSString *longitude;//经度
@property (nonatomic, strong) NSArray *picture;//图片
@property (nonatomic, copy  ) NSString *latitude;//纬度
@property (nonatomic, assign) double createDate;//订单报修时间
@property (nonatomic, assign) double appointmentTime;//预约时间
@property (nonatomic, copy  ) NSString *address;//设备所在地
@property (nonatomic, assign) double updateDate;//订单报修时间
@property (nonatomic, copy  ) NSString *telephone;//联系电话
@property (nonatomic, copy  ) NSString *remarks;//订单备注
@property (nonatomic, copy  ) NSString *brandModel;//品牌型号
@property (nonatomic, assign) double mId;//设备id
@property (nonatomic , copy ) NSString *province;//设备所在省

+ (instancetype)modelObjectWithDictionary:(NSDictionary *)dict;
- (instancetype)initWithDictionary:(NSDictionary *)dict;
- (NSDictionary *)dictionaryRepresentation;

@end
