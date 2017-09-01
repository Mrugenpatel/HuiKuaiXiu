//
//  HKXMineShoppingCartUpdateCartNumberData.h
//
//  Created by   on 2017/8/31
//  Copyright (c) 2017 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>



@interface HKXMineShoppingCartUpdateCartNumberData : NSObject <NSCoding, NSCopying>

@property (nonatomic, assign) long   buymid;//买家用户编号
@property (nonatomic, assign) long   carid;//购物车主键id
@property (nonatomic, assign) long   mid;//卖家用户编号
@property (nonatomic, assign) double price;//单价
@property (nonatomic, copy  ) NSString *goodsname;//商品名称
@property (nonatomic, copy  ) NSString *model;//型号
@property (nonatomic, copy  ) NSString *picture;//图片（单张）
@property (nonatomic, assign) int       buynumber;//购买数量
@property (nonatomic, assign) double totalprice;//总价（单价*数量）
@property (nonatomic, copy  ) NSString *companyname;//公司名（卖家的公司）
@property (nonatomic, assign) int     pid;//商品id（配件）

+ (instancetype)modelObjectWithDictionary:(NSDictionary *)dict;
- (instancetype)initWithDictionary:(NSDictionary *)dict;
- (NSDictionary *)dictionaryRepresentation;

@end
