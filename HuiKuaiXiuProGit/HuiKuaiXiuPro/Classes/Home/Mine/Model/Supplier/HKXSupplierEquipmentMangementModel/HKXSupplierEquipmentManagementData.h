//
//  HKXSupplierEquipmentManagementData.h
//
//  Created by   on 2017/7/28
//  Copyright (c) 2017 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>



@interface HKXSupplierEquipmentManagementData : NSObject <NSCoding, NSCopying>

@property (nonatomic, assign) int        state;
@property (nonatomic, copy  ) NSString * compname;
@property (nonatomic, assign) int        pmaId;
@property (nonatomic, copy  ) NSString *createBy;
@property (nonatomic, copy  ) NSString *updateBy;
@property (nonatomic, assign) double createDate;
@property (nonatomic, copy  ) NSString *brand;
@property (nonatomic, copy  ) NSString *picture;
@property (nonatomic, copy  ) NSString *type;
@property (nonatomic, copy  ) NSString *parameter;
@property (nonatomic, copy  ) NSString *bewrite;
@property (nonatomic, assign) double updateDate;
@property (nonatomic, copy  ) NSString *modelnum;
@property (nonatomic, copy  ) NSString *remarks;
@property (nonatomic, assign) long       mId;

+ (instancetype)modelObjectWithDictionary:(NSDictionary *)dict;
- (instancetype)initWithDictionary:(NSDictionary *)dict;
- (NSDictionary *)dictionaryRepresentation;

@end
