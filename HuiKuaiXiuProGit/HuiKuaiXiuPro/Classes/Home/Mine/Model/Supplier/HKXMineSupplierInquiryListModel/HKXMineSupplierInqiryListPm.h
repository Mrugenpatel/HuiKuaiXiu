//
//  HKXMineSupplierInqiryListPm.h
//
//  Created by   on 2017/8/31
//  Copyright (c) 2017 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>



@interface HKXMineSupplierInqiryListPm : NSObject <NSCoding, NSCopying>

@property (nonatomic, copy) NSString *modelnum;//设备型号
@property (nonatomic, copy) NSString *brand;//设备品牌
@property (nonatomic, copy) NSString *parameter;//设备参数
@property (nonatomic, copy) NSString *type;//设备分类
@property (nonatomic, copy) NSString *picture;//设备图片

+ (instancetype)modelObjectWithDictionary:(NSDictionary *)dict;
- (instancetype)initWithDictionary:(NSDictionary *)dict;
- (NSDictionary *)dictionaryRepresentation;

@end
