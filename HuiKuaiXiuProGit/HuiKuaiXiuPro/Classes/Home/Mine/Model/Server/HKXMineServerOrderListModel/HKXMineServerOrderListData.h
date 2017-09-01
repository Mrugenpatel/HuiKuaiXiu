//
//  HKXMineServerOrderListData.h
//
//  Created by   on 2017/8/14
//  Copyright (c) 2017 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>



@interface HKXMineServerOrderListData : NSObject <NSCoding, NSCopying>

@property (nonatomic, assign) double repairId;
@property (nonatomic, copy  ) NSString *repairName;
@property (nonatomic, copy  ) NSString *fault;
@property (nonatomic, assign) double hourCost;
@property (nonatomic, copy  ) NSString *repairexplain;
@property (nonatomic, copy  ) NSString *contact;
@property (nonatomic, copy  ) NSString *faultInfo;
@property (nonatomic, assign) int       repairStatus;
@property (nonatomic, strong) NSArray *picture;
@property (nonatomic, copy  ) NSString *address;
@property (nonatomic, assign) double updateDate;
@property (nonatomic, copy  ) NSString *repairPhone;
@property (nonatomic, copy  ) NSString *telephone;
@property (nonatomic, copy  ) NSString *brandModel;
@property (nonatomic, assign) double partsCost;
@property (nonatomic, assign) double cost;

+ (instancetype)modelObjectWithDictionary:(NSDictionary *)dict;
- (instancetype)initWithDictionary:(NSDictionary *)dict;
- (NSDictionary *)dictionaryRepresentation;

@end
