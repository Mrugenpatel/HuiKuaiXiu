//
//  HKXMineShoppingCartListShopcartList.m
//
//  Created by   on 2017/8/30
//  Copyright (c) 2017 __MyCompanyName__. All rights reserved.
//

#import "HKXMineShoppingCartListShopcartList.h"


//NSString *const kHKXMineShoppingCartListShopcartListBuymid = @"buymid";
NSString *const kHKXMineShoppingCartListShopcartListCarid = @"carid";
NSString *const kHKXMineShoppingCartListShopcartListMid = @"mid";
NSString *const kHKXMineShoppingCartListShopcartListPrice = @"price";
NSString *const kHKXMineShoppingCartListShopcartListGoodsname = @"goodsname";
NSString *const kHKXMineShoppingCartListShopcartListModel = @"model";
NSString *const kHKXMineShoppingCartListShopcartListPicture = @"picture";
NSString *const kHKXMineShoppingCartListShopcartListBuynumber = @"buynumber";
NSString *const kHKXMineShoppingCartListShopcartListTotalprice = @"totalprice";
//NSString *const kHKXMineShoppingCartListShopcartListCompanyname = @"companyname";
NSString *const kHKXMineShoppingCartListShopcartListPid = @"pid";
NSString *const kHKXMineShoppingCartListShopcartListCompanyid = @"companyid";


@interface HKXMineShoppingCartListShopcartList ()

- (id)objectOrNilForKey:(id)aKey fromDictionary:(NSDictionary *)dict;

@end

@implementation HKXMineShoppingCartListShopcartList

//@synthesize buymid = _buymid;
@synthesize carid = _carid;
@synthesize mid = _mid;
@synthesize price = _price;
@synthesize goodsname = _goodsname;
@synthesize model = _model;
@synthesize picture = _picture;
@synthesize buynumber = _buynumber;
@synthesize totalprice = _totalprice;
//@synthesize companyname = _companyname;
@synthesize pid = _pid;
@synthesize companyid = _companyid;


+ (instancetype)modelObjectWithDictionary:(NSDictionary *)dict
{
    return [[self alloc] initWithDictionary:dict];
}

- (instancetype)initWithDictionary:(NSDictionary *)dict
{
    self = [super init];
    
    // This check serves to make sure that a non-NSDictionary object
    // passed into the model class doesn't break the parsing.
    if(self && [dict isKindOfClass:[NSDictionary class]]) {
//            self.buymid = [[self objectOrNilForKey:kHKXMineShoppingCartListShopcartListBuymid fromDictionary:dict] doubleValue];
            self.carid = [[self objectOrNilForKey:kHKXMineShoppingCartListShopcartListCarid fromDictionary:dict] doubleValue];
            self.mid = [[self objectOrNilForKey:kHKXMineShoppingCartListShopcartListMid fromDictionary:dict] doubleValue];
            self.price = [[self objectOrNilForKey:kHKXMineShoppingCartListShopcartListPrice fromDictionary:dict] doubleValue];
            self.goodsname = [self objectOrNilForKey:kHKXMineShoppingCartListShopcartListGoodsname fromDictionary:dict];
            self.model = [self objectOrNilForKey:kHKXMineShoppingCartListShopcartListModel fromDictionary:dict];
            self.picture = [self objectOrNilForKey:kHKXMineShoppingCartListShopcartListPicture fromDictionary:dict];
            self.buynumber = [[self objectOrNilForKey:kHKXMineShoppingCartListShopcartListBuynumber fromDictionary:dict] doubleValue];
            self.totalprice = [[self objectOrNilForKey:kHKXMineShoppingCartListShopcartListTotalprice fromDictionary:dict] doubleValue];
//            self.companyname = [self objectOrNilForKey:kHKXMineShoppingCartListShopcartListCompanyname fromDictionary:dict];
            self.pid = [[self objectOrNilForKey:kHKXMineShoppingCartListShopcartListPid fromDictionary:dict] doubleValue];
        self.companyid = [[self objectOrNilForKey:kHKXMineShoppingCartListShopcartListCompanyid fromDictionary:dict] longValue];

    }
    
    return self;
    
}

- (NSDictionary *)dictionaryRepresentation
{
    NSMutableDictionary *mutableDict = [NSMutableDictionary dictionary];
//    [mutableDict setValue:[NSNumber numberWithDouble:self.buymid] forKey:kHKXMineShoppingCartListShopcartListBuymid];
    [mutableDict setValue:[NSNumber numberWithDouble:self.carid] forKey:kHKXMineShoppingCartListShopcartListCarid];
    [mutableDict setValue:[NSNumber numberWithDouble:self.mid] forKey:kHKXMineShoppingCartListShopcartListMid];
    [mutableDict setValue:[NSNumber numberWithDouble:self.price] forKey:kHKXMineShoppingCartListShopcartListPrice];
    [mutableDict setValue:self.goodsname forKey:kHKXMineShoppingCartListShopcartListGoodsname];
    [mutableDict setValue:self.model forKey:kHKXMineShoppingCartListShopcartListModel];
    [mutableDict setValue:self.picture forKey:kHKXMineShoppingCartListShopcartListPicture];
    [mutableDict setValue:[NSNumber numberWithDouble:self.buynumber] forKey:kHKXMineShoppingCartListShopcartListBuynumber];
    [mutableDict setValue:[NSNumber numberWithDouble:self.totalprice] forKey:kHKXMineShoppingCartListShopcartListTotalprice];
//    [mutableDict setValue:self.companyname forKey:kHKXMineShoppingCartListShopcartListCompanyname];
    [mutableDict setValue:[NSNumber numberWithDouble:self.pid] forKey:kHKXMineShoppingCartListShopcartListPid];
    [mutableDict setValue:[NSNumber numberWithLong:self.companyid] forKey:kHKXMineShoppingCartListShopcartListCompanyid];

    return [NSDictionary dictionaryWithDictionary:mutableDict];
}

- (NSString *)description 
{
    return [NSString stringWithFormat:@"%@", [self dictionaryRepresentation]];
}

#pragma mark - Helper Method
- (id)objectOrNilForKey:(id)aKey fromDictionary:(NSDictionary *)dict
{
    id object = [dict objectForKey:aKey];
    return [object isEqual:[NSNull null]] ? nil : object;
}


#pragma mark - NSCoding Methods

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super init];

//    self.buymid = [aDecoder decodeDoubleForKey:kHKXMineShoppingCartListShopcartListBuymid];
    self.carid = [aDecoder decodeDoubleForKey:kHKXMineShoppingCartListShopcartListCarid];
    self.mid = [aDecoder decodeDoubleForKey:kHKXMineShoppingCartListShopcartListMid];
    self.price = [aDecoder decodeDoubleForKey:kHKXMineShoppingCartListShopcartListPrice];
    self.goodsname = [aDecoder decodeObjectForKey:kHKXMineShoppingCartListShopcartListGoodsname];
    self.model = [aDecoder decodeObjectForKey:kHKXMineShoppingCartListShopcartListModel];
    self.picture = [aDecoder decodeObjectForKey:kHKXMineShoppingCartListShopcartListPicture];
    self.buynumber = [aDecoder decodeDoubleForKey:kHKXMineShoppingCartListShopcartListBuynumber];
    self.totalprice = [aDecoder decodeDoubleForKey:kHKXMineShoppingCartListShopcartListTotalprice];
//    self.companyname = [aDecoder decodeObjectForKey:kHKXMineShoppingCartListShopcartListCompanyname];
    self.pid = [aDecoder decodeDoubleForKey:kHKXMineShoppingCartListShopcartListPid];
    self.companyid = [aDecoder decodeDoubleForKey:kHKXMineShoppingCartListShopcartListCompanyid];
    self.isSelected = [aDecoder decodeBoolForKey:@"isSelected"];
    
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{

//    [aCoder encodeDouble:_buymid forKey:kHKXMineShoppingCartListShopcartListBuymid];
    [aCoder encodeDouble:_carid forKey:kHKXMineShoppingCartListShopcartListCarid];
    [aCoder encodeDouble:_mid forKey:kHKXMineShoppingCartListShopcartListMid];
    [aCoder encodeDouble:_price forKey:kHKXMineShoppingCartListShopcartListPrice];
    [aCoder encodeObject:_goodsname forKey:kHKXMineShoppingCartListShopcartListGoodsname];
    [aCoder encodeObject:_model forKey:kHKXMineShoppingCartListShopcartListModel];
    [aCoder encodeObject:_picture forKey:kHKXMineShoppingCartListShopcartListPicture];
    [aCoder encodeDouble:_buynumber forKey:kHKXMineShoppingCartListShopcartListBuynumber];
    [aCoder encodeDouble:_totalprice forKey:kHKXMineShoppingCartListShopcartListTotalprice];
//    [aCoder encodeObject:_companyname forKey:kHKXMineShoppingCartListShopcartListCompanyname];
    [aCoder encodeDouble:_pid forKey:kHKXMineShoppingCartListShopcartListPid];
    [aCoder encodeDouble:_companyid forKey:kHKXMineShoppingCartListShopcartListCompanyid];
    [aCoder encodeBool:_isSelected forKey:@"isSelected"];
}

- (id)copyWithZone:(NSZone *)zone
{
    HKXMineShoppingCartListShopcartList *copy = [[HKXMineShoppingCartListShopcartList alloc] init];
    
    if (copy) {

//        copy.buymid = self.buymid;
        copy.carid = self.carid;
        copy.mid = self.mid;
        copy.price = self.price;
        copy.goodsname = [self.goodsname copyWithZone:zone];
        copy.model = [self.model copyWithZone:zone];
        copy.picture = [self.picture copyWithZone:zone];
        copy.buynumber = self.buynumber;
        copy.totalprice = self.totalprice;
//        copy.companyname = [self.companyname copyWithZone:zone];
        copy.pid = self.pid;
        copy.companyid = self.companyid;
    }
    
    return copy;
}


@end
