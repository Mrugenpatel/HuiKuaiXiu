//
//  HKXSupplierPartsManagementData.h
//
//  Created by   on 2017/7/27
//  Copyright (c) 2017 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>



@interface HKXSupplierPartsManagementData : NSObject <NSCoding, NSCopying>

@property (nonatomic, copy  ) NSString *category;
@property (nonatomic, assign) double delFlag;
@property (nonatomic, copy  ) NSString *applyCareModel;
@property (nonatomic, copy  ) NSString *updateBy;
@property (nonatomic, assign) double createDate;
@property (nonatomic, copy  ) NSString *picture;
@property (nonatomic, copy  ) NSString *brand;
@property (nonatomic, assign) int stock;
@property (nonatomic, copy  ) NSString *basename;
@property (nonatomic, assign) double price;
@property (nonatomic, copy  ) NSString *address;
@property (nonatomic, copy  ) NSString *introduct;
@property (nonatomic, assign) long number;
@property (nonatomic, assign) double updateDate;
@property (nonatomic, assign) int pId;
@property (nonatomic, copy  ) NSString *model;
@property (nonatomic, assign) int status;
@property (nonatomic, assign) long mId;

+ (instancetype)modelObjectWithDictionary:(NSDictionary *)dict;
- (instancetype)initWithDictionary:(NSDictionary *)dict;
- (NSDictionary *)dictionaryRepresentation;

@end
