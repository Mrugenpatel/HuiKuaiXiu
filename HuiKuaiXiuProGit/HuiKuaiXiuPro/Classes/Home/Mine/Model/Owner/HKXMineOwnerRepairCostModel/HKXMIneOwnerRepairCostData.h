//
//  HKXMIneOwnerRepairCostData.h
//
//  Created by   on 2017/8/11
//  Copyright (c) 2017 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>



@interface HKXMIneOwnerRepairCostData : NSObject <NSCoding, NSCopying>

@property (nonatomic, assign) double partsCost;
@property (nonatomic, assign) double hourCost;
@property (nonatomic, assign) double cost;

+ (instancetype)modelObjectWithDictionary:(NSDictionary *)dict;
- (instancetype)initWithDictionary:(NSDictionary *)dict;
- (NSDictionary *)dictionaryRepresentation;

@end
