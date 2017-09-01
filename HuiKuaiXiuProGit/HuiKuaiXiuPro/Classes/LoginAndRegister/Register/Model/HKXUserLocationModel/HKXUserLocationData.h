//
//  HKXUserLocationData.h
//
//  Created by   on 2017/7/21
//  Copyright (c) 2017 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>



@interface HKXUserLocationData : NSObject <NSCoding, NSCopying>

@property (nonatomic, copy) NSString *region;
@property (nonatomic, copy) NSString *province;
@property (nonatomic, copy) NSString *city;

+ (instancetype)modelObjectWithDictionary:(NSDictionary *)dict;
- (instancetype)initWithDictionary:(NSDictionary *)dict;
- (NSDictionary *)dictionaryRepresentation;

@end
