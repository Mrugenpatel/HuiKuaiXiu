//
//  HKXMIneOwnerRepairCostModel.h
//
//  Created by   on 2017/8/11
//  Copyright (c) 2017 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@class HKXMIneOwnerRepairCostData;

@interface HKXMIneOwnerRepairCostModel : NSObject <NSCoding, NSCopying>

@property (nonatomic, copy ) NSString *message;
@property (nonatomic, assign) BOOL success;
@property (nonatomic, strong) HKXMIneOwnerRepairCostData *data;

+ (instancetype)modelObjectWithDictionary:(NSDictionary *)dict;
- (instancetype)initWithDictionary:(NSDictionary *)dict;
- (NSDictionary *)dictionaryRepresentation;

@end
