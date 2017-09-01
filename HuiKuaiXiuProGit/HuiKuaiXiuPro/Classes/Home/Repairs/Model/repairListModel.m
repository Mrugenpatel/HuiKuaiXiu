//
//  maintainerModel.m
//  HuiKuaiXiuPro
//
//  Created by daemona on 2017/8/1.
//  Copyright © 2017年 Lee. All rights reserved.
//

#import "repairListModel.h"

@implementation repairListModel
//repairId	Long	报修单Id
//@property (nonatomic, assign) long repairId;
////brandModel	String	品牌型号
//@property (nonatomic, copy) NSString * brandModel;
////mId	Long	设备id
//@property (nonatomic, assign) long mId;
////address	String	设备所在地
//@property (nonatomic, copy) NSString * address;
////longitude	String	经度
//@property (nonatomic, copy) NSString * longitude;
////latitude	String	纬度
//@property (nonatomic, copy) NSString * latitude;
////contact	String	联系人
//@property (nonatomic, copy) NSString * contact;
////telephone	String	联系电话
//@property (nonatomic, copy) NSString * telephone;
////workHours	String	设备工作时长
//@property (nonatomic, copy) NSString * workHours;
////fault	String	故障类型
//@property (nonatomic, copy) NSString * fault;
////faultInfo	String	故障描述
//@property (nonatomic, copy) NSString * faultInfo;
////picture	List<String>	图片
//@property (nonatomic, copy) NSString * picture;
////appointmentTime	Date	预约时间
//@property (nonatomic, copy) NSString * appointmentTime;
////repairStatus	Integer	维修状态 0 可以接单
//@property (nonatomic, assign) NSInteger  repairStatus;
////uId	Long	报修人Id
//@property (nonatomic, assign) long * uId;
////createDate	Date	订单报修时间
//@property (nonatomic, strong) NSDate * createDate;
////updateDate	Date	订单开始维修时间
//@property (nonatomic, strong) NSDate * updateDate;
////remarks	String	订单备注
//@property (nonatomic, copy) NSString * remarks;
- (instancetype)initWithDict:(NSDictionary *)dic{
    
    if (self = [super init]) {
        
        _repairId = dic[@"repairId"];
        _brandModel = dic[@"brandModel"];
        _mId = dic[@"brandModel"] ;
        _address = dic[@"address"];
        _longitude = dic[@"longitude"];
        _latitude = dic[@"latitude"];
        _contact = dic[@"contact"];
        _telephone = dic[@"telephone"];
        _workHours = dic[@"workHours"];
        _fault = dic[@"fault"];
        _faultInfo = dic[@"faultInfo"];
        _picture = dic[@"picture"];
        NSString *string = dic[@"appointmentTime"];
        if (![string isKindOfClass:[NSNull class]]) {
            NSTimeInterval second = string.longLongValue / 1000.0;
            NSDate *date = [NSDate dateWithTimeIntervalSince1970:second];
            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
            [dateFormatter setDateFormat:@"yyyy-MM-dd EEEE"];
            NSString *strDate = [dateFormatter stringFromDate:date];
            _appointmentTime = strDate;
        }else{
            
            _appointmentTime = dic[@"appointmentTime"];
        }
       
        _repairStatus = dic[@"repairStatus"];
        _uId = dic[@"uId"] ;
        _createDate = dic[@"createDate"];
        _updateDate = dic[@"updateDate"];
        _remarks = dic[@"remarks"];
        _repairexplain = dic[@"repairexplain"];
    }
    return self;
}

+ (instancetype)ordersWithDict:(NSDictionary *)dict{
    
    return [[self alloc] initWithDict:dict];
}

+ (NSMutableArray *)ordersWithArray:(NSArray *)array{
    
    NSMutableArray *arrayM = [NSMutableArray array];
    for (NSDictionary *dict in array) {
        repairListModel *order = [repairListModel ordersWithDict:dict];
        [arrayM addObject:order];
    }
    return arrayM;
}

@end
