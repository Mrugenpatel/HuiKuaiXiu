//
//  HKXMIneOwnerRepairCostModel.m
//
//  Created by   on 2017/8/11
//  Copyright (c) 2017 __MyCompanyName__. All rights reserved.
//

#import "HKXMIneOwnerRepairCostModel.h"
#import "HKXMIneOwnerRepairCostData.h"


NSString *const kHKXMIneOwnerRepairCostModelMessage = @"message";
NSString *const kHKXMIneOwnerRepairCostModelSuccess = @"success";
NSString *const kHKXMIneOwnerRepairCostModelData = @"data";


@interface HKXMIneOwnerRepairCostModel ()

- (id)objectOrNilForKey:(id)aKey fromDictionary:(NSDictionary *)dict;

@end

@implementation HKXMIneOwnerRepairCostModel

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
            self.message = [self objectOrNilForKey:kHKXMIneOwnerRepairCostModelMessage fromDictionary:dict];
            self.success = [[self objectOrNilForKey:kHKXMIneOwnerRepairCostModelSuccess fromDictionary:dict] boolValue];
            self.data = [HKXMIneOwnerRepairCostData modelObjectWithDictionary:[dict objectForKey:kHKXMIneOwnerRepairCostModelData]];

    }
    
    return self;
    
}

- (NSDictionary *)dictionaryRepresentation
{
    NSMutableDictionary *mutableDict = [NSMutableDictionary dictionary];
    [mutableDict setValue:self.message forKey:kHKXMIneOwnerRepairCostModelMessage];
    [mutableDict setValue:[NSNumber numberWithBool:self.success] forKey:kHKXMIneOwnerRepairCostModelSuccess];
    [mutableDict setValue:[self.data dictionaryRepresentation] forKey:kHKXMIneOwnerRepairCostModelData];

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

    self.message = [aDecoder decodeObjectForKey:kHKXMIneOwnerRepairCostModelMessage];
    self.success = [aDecoder decodeBoolForKey:kHKXMIneOwnerRepairCostModelSuccess];
    self.data = [aDecoder decodeObjectForKey:kHKXMIneOwnerRepairCostModelData];
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{

    [aCoder encodeObject:_message forKey:kHKXMIneOwnerRepairCostModelMessage];
    [aCoder encodeBool:_success forKey:kHKXMIneOwnerRepairCostModelSuccess];
    [aCoder encodeObject:_data forKey:kHKXMIneOwnerRepairCostModelData];
}

- (id)copyWithZone:(NSZone *)zone
{
    HKXMIneOwnerRepairCostModel *copy = [[HKXMIneOwnerRepairCostModel alloc] init];
    
    if (copy) {

        copy.message = [self.message copyWithZone:zone];
        copy.success = self.success;
        copy.data = [self.data copyWithZone:zone];
    }
    
    return copy;
}


@end
