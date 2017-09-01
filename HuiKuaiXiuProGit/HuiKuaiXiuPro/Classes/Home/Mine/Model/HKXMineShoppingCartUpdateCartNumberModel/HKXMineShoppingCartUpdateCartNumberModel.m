//
//  HKXMineShoppingCartUpdateCartNumberModel.m
//
//  Created by   on 2017/8/31
//  Copyright (c) 2017 __MyCompanyName__. All rights reserved.
//

#import "HKXMineShoppingCartUpdateCartNumberModel.h"
#import "HKXMineShoppingCartUpdateCartNumberData.h"


NSString *const kHKXMineShoppingCartUpdateCartNumberModelMessage = @"message";
NSString *const kHKXMineShoppingCartUpdateCartNumberModelSuccess = @"success";
NSString *const kHKXMineShoppingCartUpdateCartNumberModelData = @"data";


@interface HKXMineShoppingCartUpdateCartNumberModel ()

- (id)objectOrNilForKey:(id)aKey fromDictionary:(NSDictionary *)dict;

@end

@implementation HKXMineShoppingCartUpdateCartNumberModel

@synthesize message = _message;
@synthesize success = _success;
@synthesize data = _data;


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
            self.message = [self objectOrNilForKey:kHKXMineShoppingCartUpdateCartNumberModelMessage fromDictionary:dict];
            self.success = [[self objectOrNilForKey:kHKXMineShoppingCartUpdateCartNumberModelSuccess fromDictionary:dict] boolValue];
            self.data = [HKXMineShoppingCartUpdateCartNumberData modelObjectWithDictionary:[dict objectForKey:kHKXMineShoppingCartUpdateCartNumberModelData]];

    }
    
    return self;
    
}

- (NSDictionary *)dictionaryRepresentation
{
    NSMutableDictionary *mutableDict = [NSMutableDictionary dictionary];
    [mutableDict setValue:self.message forKey:kHKXMineShoppingCartUpdateCartNumberModelMessage];
    [mutableDict setValue:[NSNumber numberWithBool:self.success] forKey:kHKXMineShoppingCartUpdateCartNumberModelSuccess];
    [mutableDict setValue:[self.data dictionaryRepresentation] forKey:kHKXMineShoppingCartUpdateCartNumberModelData];

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

    self.message = [aDecoder decodeObjectForKey:kHKXMineShoppingCartUpdateCartNumberModelMessage];
    self.success = [aDecoder decodeBoolForKey:kHKXMineShoppingCartUpdateCartNumberModelSuccess];
    self.data = [aDecoder decodeObjectForKey:kHKXMineShoppingCartUpdateCartNumberModelData];
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{

    [aCoder encodeObject:_message forKey:kHKXMineShoppingCartUpdateCartNumberModelMessage];
    [aCoder encodeBool:_success forKey:kHKXMineShoppingCartUpdateCartNumberModelSuccess];
    [aCoder encodeObject:_data forKey:kHKXMineShoppingCartUpdateCartNumberModelData];
}

- (id)copyWithZone:(NSZone *)zone
{
    HKXMineShoppingCartUpdateCartNumberModel *copy = [[HKXMineShoppingCartUpdateCartNumberModel alloc] init];
    
    if (copy) {

        copy.message = [self.message copyWithZone:zone];
        copy.success = self.success;
        copy.data = [self.data copyWithZone:zone];
    }
    
    return copy;
}


@end
