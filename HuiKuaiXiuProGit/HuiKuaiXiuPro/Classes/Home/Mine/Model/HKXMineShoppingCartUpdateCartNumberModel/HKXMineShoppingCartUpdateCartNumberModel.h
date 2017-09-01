//
//  HKXMineShoppingCartUpdateCartNumberModel.h
//
//  Created by   on 2017/8/31
//  Copyright (c) 2017 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@class HKXMineShoppingCartUpdateCartNumberData;

@interface HKXMineShoppingCartUpdateCartNumberModel : NSObject <NSCoding, NSCopying>

@property (nonatomic, copy  ) NSString *message;
@property (nonatomic, assign) BOOL success;
@property (nonatomic, strong) HKXMineShoppingCartUpdateCartNumberData *data;

+ (instancetype)modelObjectWithDictionary:(NSDictionary *)dict;
- (instancetype)initWithDictionary:(NSDictionary *)dict;
- (NSDictionary *)dictionaryRepresentation;

@end
