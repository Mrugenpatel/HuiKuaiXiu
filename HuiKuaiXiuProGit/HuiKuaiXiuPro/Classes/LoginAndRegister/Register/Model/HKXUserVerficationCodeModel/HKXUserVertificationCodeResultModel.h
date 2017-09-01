//
//  HKXUserVertificationCodeResultModel.h
//
//  Created by   on 2017/7/21
//  Copyright (c) 2017 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@class HKXUserVertificationCodeData;

@interface HKXUserVertificationCodeResultModel : NSObject <NSCoding, NSCopying>

@property (nonatomic, copy  ) NSString * message;//修改后返回成功或失败原因
@property (nonatomic, assign) BOOL       success;//修改成功为true 其它情况为false
@property (nonatomic, strong) HKXUserVertificationCodeData * data;

+ (instancetype)modelObjectWithDictionary:(NSDictionary *)dict;
- (instancetype)initWithDictionary:(NSDictionary *)dict;
- (NSDictionary *)dictionaryRepresentation;

@end
