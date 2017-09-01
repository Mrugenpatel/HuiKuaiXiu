//
//  HKXMineOwnerInfoModel.m
//
//  Created by   on 2017/7/25
//  Copyright (c) 2017 __MyCompanyName__. All rights reserved.
//

#import "HKXMineOwnerInfoModel.h"
#import "HKXMineOwnerInfoData.h"


NSString *const kHKXMineOwnerInfoModelMessage = @"message";
NSString *const kHKXMineOwnerInfoModelSuccess = @"success";
NSString *const kHKXMineOwnerInfoModelData = @"data";


@interface HKXMineOwnerInfoModel ()

- (id)objectOrNilForKey:(id)aKey fromDictionary:(NSDictionary *)dict;

@end

@implementation HKXMineOwnerInfoModel

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
            self.message = [self objectOrNilForKey:kHKXMineOwnerInfoModelMessage fromDictionary:dict];
            self.success = [[self objectOrNilForKey:kHKXMineOwnerInfoModelSuccess fromDictionary:dict] boolValue];
            self.data = [HKXMineOwnerInfoData modelObjectWithDictionary:[dict objectForKey:kHKXMineOwnerInfoModelData]];

    }
    
    return self;
    
}

- (NSDictionary *)dictionaryRepresentation
{
    NSMutableDictionary *mutableDict = [NSMutableDictionary dictionary];
    [mutableDict setValue:self.message forKey:kHKXMineOwnerInfoModelMessage];
    [mutableDict setValue:[NSNumber numberWithBool:self.success] forKey:kHKXMineOwnerInfoModelSuccess];
    [mutableDict setValue:[self.data dictionaryRepresentation] forKey:kHKXMineOwnerInfoModelData];

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

    self.message = [aDecoder decodeObjectForKey:kHKXMineOwnerInfoModelMessage];
    self.success = [aDecoder decodeBoolForKey:kHKXMineOwnerInfoModelSuccess];
    self.data = [aDecoder decodeObjectForKey:kHKXMineOwnerInfoModelData];
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{

    [aCoder encodeObject:_message forKey:kHKXMineOwnerInfoModelMessage];
    [aCoder encodeBool:_success forKey:kHKXMineOwnerInfoModelSuccess];
    [aCoder encodeObject:_data forKey:kHKXMineOwnerInfoModelData];
}

- (id)copyWithZone:(NSZone *)zone
{
    HKXMineOwnerInfoModel *copy = [[HKXMineOwnerInfoModel alloc] init];
    
    if (copy) {

        copy.message = [self.message copyWithZone:zone];
        copy.success = self.success;
        copy.data = [self.data copyWithZone:zone];
    }
    
    return copy;
}


@end
