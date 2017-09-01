//
//  HKXMineShoppingCartListData.m
//
//  Created by   on 2017/8/30
//  Copyright (c) 2017 __MyCompanyName__. All rights reserved.
//

#import "HKXMineShoppingCartListData.h"
#import "HKXMineShoppingCartListShopcartList.h"


NSString *const kHKXMineShoppingCartListDataCompanyname = @"companyname";
NSString *const kHKXMineShoppingCartListDataCompanyid = @"companyid";
NSString *const kHKXMineShoppingCartListDataMid = @"mid";
NSString *const kHKXMineShoppingCartListDataBuy = @"buy";
NSString *const kHKXMineShoppingCartListDataShopcartList = @"shopcartList";


@interface HKXMineShoppingCartListData ()

- (id)objectOrNilForKey:(id)aKey fromDictionary:(NSDictionary *)dict;

@end

@implementation HKXMineShoppingCartListData

@synthesize companyname = _companyname;
@synthesize companyid = _companyid;
@synthesize mid = _mid;
@synthesize buy = _buy;
@synthesize shopcartList = _shopcartList;


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
            self.companyname = [self objectOrNilForKey:kHKXMineShoppingCartListDataCompanyname fromDictionary:dict];
            self.companyid = [[self objectOrNilForKey:kHKXMineShoppingCartListDataCompanyid fromDictionary:dict] doubleValue];
            self.mid = [[self objectOrNilForKey:kHKXMineShoppingCartListDataMid fromDictionary:dict] doubleValue];
            self.buy = [[self objectOrNilForKey:kHKXMineShoppingCartListDataBuy fromDictionary:dict] doubleValue];
    NSObject *receivedHKXMineShoppingCartListShopcartList = [dict objectForKey:kHKXMineShoppingCartListDataShopcartList];
    NSMutableArray *parsedHKXMineShoppingCartListShopcartList = [NSMutableArray array];
    if ([receivedHKXMineShoppingCartListShopcartList isKindOfClass:[NSArray class]]) {
        for (NSDictionary *item in (NSArray *)receivedHKXMineShoppingCartListShopcartList) {
            if ([item isKindOfClass:[NSDictionary class]]) {
                [parsedHKXMineShoppingCartListShopcartList addObject:[HKXMineShoppingCartListShopcartList modelObjectWithDictionary:item]];
            }
       }
    } else if ([receivedHKXMineShoppingCartListShopcartList isKindOfClass:[NSDictionary class]]) {
       [parsedHKXMineShoppingCartListShopcartList addObject:[HKXMineShoppingCartListShopcartList modelObjectWithDictionary:(NSDictionary *)receivedHKXMineShoppingCartListShopcartList]];
    }

    self.shopcartList = [NSArray arrayWithArray:parsedHKXMineShoppingCartListShopcartList];

    }
    
    return self;
    
}

- (NSDictionary *)dictionaryRepresentation
{
    NSMutableDictionary *mutableDict = [NSMutableDictionary dictionary];
    [mutableDict setValue:self.companyname forKey:kHKXMineShoppingCartListDataCompanyname];
    [mutableDict setValue:[NSNumber numberWithDouble:self.companyid] forKey:kHKXMineShoppingCartListDataCompanyid];
    [mutableDict setValue:[NSNumber numberWithDouble:self.mid] forKey:kHKXMineShoppingCartListDataMid];
    [mutableDict setValue:[NSNumber numberWithDouble:self.buy] forKey:kHKXMineShoppingCartListDataBuy];
    NSMutableArray *tempArrayForShopcartList = [NSMutableArray array];
    for (NSObject *subArrayObject in self.shopcartList) {
        if([subArrayObject respondsToSelector:@selector(dictionaryRepresentation)]) {
            // This class is a model object
            [tempArrayForShopcartList addObject:[subArrayObject performSelector:@selector(dictionaryRepresentation)]];
        } else {
            // Generic object
            [tempArrayForShopcartList addObject:subArrayObject];
        }
    }
    [mutableDict setValue:[NSArray arrayWithArray:tempArrayForShopcartList] forKey:kHKXMineShoppingCartListDataShopcartList];

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

    self.companyname = [aDecoder decodeObjectForKey:kHKXMineShoppingCartListDataCompanyname];
    self.companyid = [aDecoder decodeDoubleForKey:kHKXMineShoppingCartListDataCompanyid];
    self.mid = [aDecoder decodeDoubleForKey:kHKXMineShoppingCartListDataMid];
    self.buy = [aDecoder decodeDoubleForKey:kHKXMineShoppingCartListDataBuy];
    self.shopcartList = [aDecoder decodeObjectForKey:kHKXMineShoppingCartListDataShopcartList];
    
    self.isSelected = [aDecoder decodeBoolForKey:@"isSelected"];
    
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{

    [aCoder encodeObject:_companyname forKey:kHKXMineShoppingCartListDataCompanyname];
    [aCoder encodeDouble:_companyid forKey:kHKXMineShoppingCartListDataCompanyid];
    [aCoder encodeDouble:_mid forKey:kHKXMineShoppingCartListDataMid];
    [aCoder encodeDouble:_buy forKey:kHKXMineShoppingCartListDataBuy];
    [aCoder encodeObject:_shopcartList forKey:kHKXMineShoppingCartListDataShopcartList];
    
    [aCoder encodeBool:_isSelected forKey:@"isSelected"];
}

- (id)copyWithZone:(NSZone *)zone
{
    HKXMineShoppingCartListData *copy = [[HKXMineShoppingCartListData alloc] init];
    
    if (copy) {

        copy.companyname = [self.companyname copyWithZone:zone];
        copy.companyid = self.companyid;
        copy.mid = self.mid;
        copy.buy = self.buy;
        copy.shopcartList = [self.shopcartList copyWithZone:zone];
    }
    
    return copy;
}


@end
