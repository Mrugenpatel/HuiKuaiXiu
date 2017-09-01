//
//  HKXMineAddressListData.h
//
//  Created by   on 2017/9/1
//  Copyright (c) 2017 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>



@interface HKXMineAddressListData : NSObject <NSCoding, NSCopying>

@property (nonatomic, copy  ) NSString *consigneesTel;//收货人地址
@property (nonatomic, assign) int       defaultSet;//默认设置（1默认收货地址0不是默认收货地址）
@property (nonatomic, assign) long      addId;//主键
@property (nonatomic, copy  ) NSString *consignees;//收货人姓名
@property (nonatomic, assign) long      uId;//用户id
@property (nonatomic, copy  ) NSString *consigneesAdd;//收货地址

+ (instancetype)modelObjectWithDictionary:(NSDictionary *)dict;
- (instancetype)initWithDictionary:(NSDictionary *)dict;
- (NSDictionary *)dictionaryRepresentation;

@end
