//
//  HKXMineOwnerEquipmentListData.h
//
//  Created by   on 2017/8/29
//  Copyright (c) 2017 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>



@interface HKXMineOwnerEquipmentListData : NSObject <NSCoding, NSCopying>

@property (nonatomic, assign) double dataIdentifier;
@property (nonatomic, copy  ) NSString *brand;//设备品牌
@property (nonatomic, copy  ) NSString *model;//设备型号
@property (nonatomic, copy  ) NSString *nameplateNum;//设备铭牌号
@property (nonatomic, copy  ) NSString *category;//设备分类
@property (nonatomic, copy  ) NSString *picture;//设备主图

+ (instancetype)modelObjectWithDictionary:(NSDictionary *)dict;
- (instancetype)initWithDictionary:(NSDictionary *)dict;
- (NSDictionary *)dictionaryRepresentation;

@end
