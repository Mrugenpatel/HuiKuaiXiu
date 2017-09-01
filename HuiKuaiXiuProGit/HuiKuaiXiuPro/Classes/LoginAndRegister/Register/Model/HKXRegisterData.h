//
//  HKXRegisterData.h
//
//  Created by   on 2017/7/4
//  Copyright (c) 2017 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>



@interface HKXRegisterData : NSObject <NSCoding, NSCopying>

@property (nonatomic, assign) long       dataIdentifier;
@property (nonatomic, copy  ) NSString * username;
@property (nonatomic, assign) int        role;
@property (nonatomic , copy) NSString * recommendCode;//推荐码

+ (instancetype)modelObjectWithDictionary:(NSDictionary *)dict;
- (instancetype)initWithDictionary:(NSDictionary *)dict;
- (NSDictionary *)dictionaryRepresentation;

@end
