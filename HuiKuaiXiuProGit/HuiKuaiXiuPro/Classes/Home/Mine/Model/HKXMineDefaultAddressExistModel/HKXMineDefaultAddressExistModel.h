//
//  HKXMineDefaultAddressExistModel.h
//
//  Created by   on 2017/9/1
//  Copyright (c) 2017 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@class HKXMineDefaultAddressExistData;

@interface HKXMineDefaultAddressExistModel : NSObject <NSCoding, NSCopying>

@property (nonatomic, copy  ) NSString * message;
@property (nonatomic, assign) BOOL success;
@property (nonatomic, strong) HKXMineDefaultAddressExistData *data;

+ (instancetype)modelObjectWithDictionary:(NSDictionary *)dict;
- (instancetype)initWithDictionary:(NSDictionary *)dict;
- (NSDictionary *)dictionaryRepresentation;

@end
