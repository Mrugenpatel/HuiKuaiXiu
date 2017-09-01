//
//  HKXMineShoppingCartListData.h
//
//  Created by   on 2017/8/30
//  Copyright (c) 2017 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>



@interface HKXMineShoppingCartListData : NSObject <NSCoding, NSCopying>

@property (nonatomic, copy  ) NSString *companyname;//公司名（卖家的公司）
@property (nonatomic, assign) double companyid;//公司id
@property (nonatomic, assign) double mid;//卖家用户编号
@property (nonatomic, assign) double buy;//买家（当前用户id）
@property (nonatomic, strong) NSArray *shopcartList;//购物车商品model数组

@property (nonatomic , assign) BOOL isSelected;//是否选中商铺全部商品

+ (instancetype)modelObjectWithDictionary:(NSDictionary *)dict;
- (instancetype)initWithDictionary:(NSDictionary *)dict;
- (NSDictionary *)dictionaryRepresentation;

@end
