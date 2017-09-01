//
//  HKXUserVertificationCodeData.h
//
//  Created by   on 2017/7/21
//  Copyright (c) 2017 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>



@interface HKXUserVertificationCodeData : NSObject <NSCoding, NSCopying>

@property (nonatomic, copy  ) NSString * number;//验证码
@property (nonatomic, assign) double     startTime;//验证码有效开始时间
@property (nonatomic, assign) double     outTime;//验证码失效时间

+ (instancetype)modelObjectWithDictionary:(NSDictionary *)dict;
- (instancetype)initWithDictionary:(NSDictionary *)dict;
- (NSDictionary *)dictionaryRepresentation;

@end
