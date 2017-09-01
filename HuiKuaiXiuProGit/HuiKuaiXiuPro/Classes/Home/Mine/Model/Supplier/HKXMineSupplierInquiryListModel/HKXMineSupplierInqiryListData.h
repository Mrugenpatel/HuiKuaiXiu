//
//  HKXMineSupplierInqiryListData.h
//
//  Created by   on 2017/8/31
//  Copyright (c) 2017 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@class HKXMineSupplierInqiryListPm;

@interface HKXMineSupplierInqiryListData : NSObject <NSCoding, NSCopying>

@property (nonatomic, copy  ) NSString *inquiryTel;//询价人电话
@property (nonatomic, assign) double inquiryId;//询价id
@property (nonatomic, copy  ) NSString *inquiryAdd;//询价人地址
@property (nonatomic, strong) HKXMineSupplierInqiryListPm *pm;//询价商品
@property (nonatomic, copy  ) NSString *inquiryName;//询价人姓名
@property (nonatomic, assign) int        mId;//设备id
@property (nonatomic, assign) double inquiryDate;//询价日期

+ (instancetype)modelObjectWithDictionary:(NSDictionary *)dict;
- (instancetype)initWithDictionary:(NSDictionary *)dict;
- (NSDictionary *)dictionaryRepresentation;

@end
