//
//  HKXMineShoppingCartUpdateCartNumberData.m
//
//  Created by   on 2017/8/31
//  Copyright (c) 2017 __MyCompanyName__. All rights reserved.
//

#import "HKXMineShoppingCartUpdateCartNumberData.h"


NSString *const kHKXMineShoppingCartUpdateCartNumberDataBuymid = @"buymid";
NSString *const kHKXMineShoppingCartUpdateCartNumberDataCarid = @"carid";
NSString *const kHKXMineShoppingCartUpdateCartNumberDataMid = @"mid";
NSString *const kHKXMineShoppingCartUpdateCartNumberDataPrice = @"price";
NSString *const kHKXMineShoppingCartUpdateCartNumberDataGoodsname = @"goodsname";
NSString *const kHKXMineShoppingCartUpdateCartNumberDataModel = @"model";
NSString *const kHKXMineShoppingCartUpdateCartNumberDataPicture = @"picture";
NSString *const kHKXMineShoppingCartUpdateCartNumberDataBuynumber = @"buynumber";
NSString *const kHKXMineShoppingCartUpdateCartNumberDataTotalprice = @"totalprice";
NSString *const kHKXMineShoppingCartUpdateCartNumberDataCompanyname = @"companyname";
NSString *const kHKXMineShoppingCartUpdateCartNumberDataPid = @"pid";


@interface HKXMineShoppingCartUpdateCartNumberData ()

- (id)objectOrNilForKey:(id)aKey fromDictionary:(NSDictionary *)dict;

@end

@implementation HKXMineShoppingCartUpdateCartNumberData

@synthesize buymid = _buymid;
@synthesize carid = _carid;
@synthesize mid = _mid;
@synthesize price = _price;
@synthesize goodsname = _goodsname;
@synthesize model = _model;
@synthesize picture = _picture;
@synthesize buynumber = _buynumber;
@synthesize totalprice = _totalprice;
@synthesize companyname = _companyname;
@synthesize pid = _pid;


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
            self.buymid = [[self objectOrNilForKey:kHKXMineShoppingCartUpdateCartNumberDataBuymid fromDictionary:dict] doubleValue];
            self.carid = [[self objectOrNilForKey:kHKXMineShoppingCartUpdateCartNumberDataCarid fromDictionary:dict] doubleValue];
            self.mid = [[self objectOrNilForKey:kHKXMineShoppingCartUpdateCartNumberDataMid fromDictionary:dict] doubleValue];
            self.price = [[self objectOrNilForKey:kHKXMineShoppingCartUpdateCartNumberDataPrice fromDictionary:dict] doubleValue];
            self.goodsname = [self objectOrNilForKey:kHKXMineShoppingCartUpdateCartNumberDataGoodsname fromDictionary:dict];
            self.model = [self objectOrNilForKey:kHKXMineShoppingCartUpdateCartNumberDataModel fromDictionary:dict];
            self.picture = [self objectOrNilForKey:kHKXMineShoppingCartUpdateCartNumberDataPicture fromDictionary:dict];
            self.buynumber = [[self objectOrNilForKey:kHKXMineShoppingCartUpdateCartNumberDataBuynumber fromDictionary:dict] doubleValue];
            self.totalprice = [[self objectOrNilForKey:kHKXMineShoppingCartUpdateCartNumberDataTotalprice fromDictionary:dict] doubleValue];
            self.companyname = [self objectOrNilForKey:kHKXMineShoppingCartUpdateCartNumberDataCompanyname fromDictionary:dict];
            self.pid = [[self objectOrNilForKey:kHKXMineShoppingCartUpdateCartNumberDataPid fromDictionary:dict] doubleValue];

    }
    
    return self;
    
}

- (NSDictionary *)dictionaryRepresentation
{
    NSMutableDictionary *mutableDict = [NSMutableDictionary dictionary];
    [mutableDict setValue:[NSNumber numberWithDouble:self.buymid] forKey:kHKXMineShoppingCartUpdateCartNumberDataBuymid];
    [mutableDict setValue:[NSNumber numberWithDouble:self.carid] forKey:kHKXMineShoppingCartUpdateCartNumberDataCarid];
    [mutableDict setValue:[NSNumber numberWithDouble:self.mid] forKey:kHKXMineShoppingCartUpdateCartNumberDataMid];
    [mutableDict setValue:[NSNumber numberWithDouble:self.price] forKey:kHKXMineShoppingCartUpdateCartNumberDataPrice];
    [mutableDict setValue:self.goodsname forKey:kHKXMineShoppingCartUpdateCartNumberDataGoodsname];
    [mutableDict setValue:self.model forKey:kHKXMineShoppingCartUpdateCartNumberDataModel];
    [mutableDict setValue:self.picture forKey:kHKXMineShoppingCartUpdateCartNumberDataPicture];
    [mutableDict setValue:[NSNumber numberWithDouble:self.buynumber] forKey:kHKXMineShoppingCartUpdateCartNumberDataBuynumber];
    [mutableDict setValue:[NSNumber numberWithDouble:self.totalprice] forKey:kHKXMineShoppingCartUpdateCartNumberDataTotalprice];
    [mutableDict setValue:self.companyname forKey:kHKXMineShoppingCartUpdateCartNumberDataCompanyname];
    [mutableDict setValue:[NSNumber numberWithDouble:self.pid] forKey:kHKXMineShoppingCartUpdateCartNumberDataPid];

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

    self.buymid = [aDecoder decodeDoubleForKey:kHKXMineShoppingCartUpdateCartNumberDataBuymid];
    self.carid = [aDecoder decodeDoubleForKey:kHKXMineShoppingCartUpdateCartNumberDataCarid];
    self.mid = [aDecoder decodeDoubleForKey:kHKXMineShoppingCartUpdateCartNumberDataMid];
    self.price = [aDecoder decodeDoubleForKey:kHKXMineShoppingCartUpdateCartNumberDataPrice];
    self.goodsname = [aDecoder decodeObjectForKey:kHKXMineShoppingCartUpdateCartNumberDataGoodsname];
    self.model = [aDecoder decodeObjectForKey:kHKXMineShoppingCartUpdateCartNumberDataModel];
    self.picture = [aDecoder decodeObjectForKey:kHKXMineShoppingCartUpdateCartNumberDataPicture];
    self.buynumber = [aDecoder decodeDoubleForKey:kHKXMineShoppingCartUpdateCartNumberDataBuynumber];
    self.totalprice = [aDecoder decodeDoubleForKey:kHKXMineShoppingCartUpdateCartNumberDataTotalprice];
    self.companyname = [aDecoder decodeObjectForKey:kHKXMineShoppingCartUpdateCartNumberDataCompanyname];
    self.pid = [aDecoder decodeDoubleForKey:kHKXMineShoppingCartUpdateCartNumberDataPid];
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{

    [aCoder encodeDouble:_buymid forKey:kHKXMineShoppingCartUpdateCartNumberDataBuymid];
    [aCoder encodeDouble:_carid forKey:kHKXMineShoppingCartUpdateCartNumberDataCarid];
    [aCoder encodeDouble:_mid forKey:kHKXMineShoppingCartUpdateCartNumberDataMid];
    [aCoder encodeDouble:_price forKey:kHKXMineShoppingCartUpdateCartNumberDataPrice];
    [aCoder encodeObject:_goodsname forKey:kHKXMineShoppingCartUpdateCartNumberDataGoodsname];
    [aCoder encodeObject:_model forKey:kHKXMineShoppingCartUpdateCartNumberDataModel];
    [aCoder encodeObject:_picture forKey:kHKXMineShoppingCartUpdateCartNumberDataPicture];
    [aCoder encodeDouble:_buynumber forKey:kHKXMineShoppingCartUpdateCartNumberDataBuynumber];
    [aCoder encodeDouble:_totalprice forKey:kHKXMineShoppingCartUpdateCartNumberDataTotalprice];
    [aCoder encodeObject:_companyname forKey:kHKXMineShoppingCartUpdateCartNumberDataCompanyname];
    [aCoder encodeDouble:_pid forKey:kHKXMineShoppingCartUpdateCartNumberDataPid];
}

- (id)copyWithZone:(NSZone *)zone
{
    HKXMineShoppingCartUpdateCartNumberData *copy = [[HKXMineShoppingCartUpdateCartNumberData alloc] init];
    
    if (copy) {

        copy.buymid = self.buymid;
        copy.carid = self.carid;
        copy.mid = self.mid;
        copy.price = self.price;
        copy.goodsname = [self.goodsname copyWithZone:zone];
        copy.model = [self.model copyWithZone:zone];
        copy.picture = [self.picture copyWithZone:zone];
        copy.buynumber = self.buynumber;
        copy.totalprice = self.totalprice;
        copy.companyname = [self.companyname copyWithZone:zone];
        copy.pid = self.pid;
    }
    
    return copy;
}


@end
