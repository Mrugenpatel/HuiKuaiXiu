//
//  HKXMineSupplierInfoModel.m
//
//  Created by   on 2017/7/25
//  Copyright (c) 2017 __MyCompanyName__. All rights reserved.
//

#import "HKXMineSupplierInfoModel.h"
#import "HKXMineSupplierInfoData.h"


NSString *const kHKXMineSupplierInfoModelMessage = @"message";
NSString *const kHKXMineSupplierInfoModelSuccess = @"success";
NSString *const kHKXMineSupplierInfoModelData = @"data";


@interface HKXMineSupplierInfoModel ()

- (id)objectOrNilForKey:(id)aKey fromDictionary:(NSDictionary *)dict;

@end

@implementation HKXMineSupplierInfoModel

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
            self.message = [self objectOrNilForKey:kHKXMineSupplierInfoModelMessage fromDictionary:dict];
            self.success = [[self objectOrNilForKey:kHKXMineSupplierInfoModelSuccess fromDictionary:dict] boolValue];
            self.data = [HKXMineSupplierInfoData modelObjectWithDictionary:[dict objectForKey:kHKXMineSupplierInfoModelData]];

    }
    
    return self;
    
}

- (NSDictionary *)dictionaryRepresentation
{
    NSMutableDictionary *mutableDict = [NSMutableDictionary dictionary];
    [mutableDict setValue:self.message forKey:kHKXMineSupplierInfoModelMessage];
    [mutableDict setValue:[NSNumber numberWithBool:self.success] forKey:kHKXMineSupplierInfoModelSuccess];
    [mutableDict setValue:[self.data dictionaryRepresentation] forKey:kHKXMineSupplierInfoModelData];

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

    self.message = [aDecoder decodeObjectForKey:kHKXMineSupplierInfoModelMessage];
    self.success = [aDecoder decodeBoolForKey:kHKXMineSupplierInfoModelSuccess];
    self.data = [aDecoder decodeObjectForKey:kHKXMineSupplierInfoModelData];
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{

    [aCoder encodeObject:_message forKey:kHKXMineSupplierInfoModelMessage];
    [aCoder encodeBool:_success forKey:kHKXMineSupplierInfoModelSuccess];
    [aCoder encodeObject:_data forKey:kHKXMineSupplierInfoModelData];
}

- (id)copyWithZone:(NSZone *)zone
{
    HKXMineSupplierInfoModel *copy = [[HKXMineSupplierInfoModel alloc] init];
    
    if (copy) {

        copy.message = [self.message copyWithZone:zone];
        copy.success = self.success;
        copy.data = [self.data copyWithZone:zone];
    }
    
    return copy;
}


@end
