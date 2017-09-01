//
//  HKXRegisterResult.h
//
//  Created by   on 2017/7/4
//  Copyright (c) 2017 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@class HKXRegisterData;

@interface HKXRegisterResult : NSObject <NSCoding, NSCopying>

@property (nonatomic, copy  ) NSString *message;
@property (nonatomic, assign) BOOL success;
@property (nonatomic, strong) HKXRegisterData *data;

+ (instancetype)modelObjectWithDictionary:(NSDictionary *)dict;
- (instancetype)initWithDictionary:(NSDictionary *)dict;
- (NSDictionary *)dictionaryRepresentation;

@end
