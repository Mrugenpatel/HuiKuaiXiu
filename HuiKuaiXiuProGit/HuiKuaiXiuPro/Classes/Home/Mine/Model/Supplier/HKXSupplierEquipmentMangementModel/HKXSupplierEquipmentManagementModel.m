//
//  HKXSupplierEquipmentManagementModel.m
//
//  Created by   on 2017/7/28
//  Copyright (c) 2017 __MyCompanyName__. All rights reserved.
//

#import "HKXSupplierEquipmentManagementModel.h"
#import "HKXSupplierEquipmentManagementData.h"


NSString *const kHKXSupplierEquipmentManagementModelMessage = @"message";
NSString *const kHKXSupplierEquipmentManagementModelSuccess = @"success";
NSString *const kHKXSupplierEquipmentManagementModelData = @"data";


@interface HKXSupplierEquipmentManagementModel ()

- (id)objectOrNilForKey:(id)aKey fromDictionary:(NSDictionary *)dict;

@end

@implementation HKXSupplierEquipmentManagementModel

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
            self.message = [self objectOrNilForKey:kHKXSupplierEquipmentManagementModelMessage fromDictionary:dict];
            self.success = [[self objectOrNilForKey:kHKXSupplierEquipmentManagementModelSuccess fromDictionary:dict] boolValue];
    NSObject *receivedHKXSupplierEquipmentManagementData = [dict objectForKey:kHKXSupplierEquipmentManagementModelData];
    NSMutableArray *parsedHKXSupplierEquipmentManagementData = [NSMutableArray array];
    if ([receivedHKXSupplierEquipmentManagementData isKindOfClass:[NSArray class]]) {
        for (NSDictionary *item in (NSArray *)receivedHKXSupplierEquipmentManagementData) {
            if ([item isKindOfClass:[NSDictionary class]]) {
                [parsedHKXSupplierEquipmentManagementData addObject:[HKXSupplierEquipmentManagementData modelObjectWithDictionary:item]];
            }
       }
    } else if ([receivedHKXSupplierEquipmentManagementData isKindOfClass:[NSDictionary class]]) {
       [parsedHKXSupplierEquipmentManagementData addObject:[HKXSupplierEquipmentManagementData modelObjectWithDictionary:(NSDictionary *)receivedHKXSupplierEquipmentManagementData]];
    }

    self.data = [NSArray arrayWithArray:parsedHKXSupplierEquipmentManagementData];

    }
    
    return self;
    
}

- (NSDictionary *)dictionaryRepresentation
{
    NSMutableDictionary *mutableDict = [NSMutableDictionary dictionary];
    [mutableDict setValue:self.message forKey:kHKXSupplierEquipmentManagementModelMessage];
    [mutableDict setValue:[NSNumber numberWithBool:self.success] forKey:kHKXSupplierEquipmentManagementModelSuccess];
    NSMutableArray *tempArrayForData = [NSMutableArray array];
    for (NSObject *subArrayObject in self.data) {
        if([subArrayObject respondsToSelector:@selector(dictionaryRepresentation)]) {
            // This class is a model object
            [tempArrayForData addObject:[subArrayObject performSelector:@selector(dictionaryRepresentation)]];
        } else {
            // Generic object
            [tempArrayForData addObject:subArrayObject];
        }
    }
    [mutableDict setValue:[NSArray arrayWithArray:tempArrayForData] forKey:kHKXSupplierEquipmentManagementModelData];

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

    self.message = [aDecoder decodeObjectForKey:kHKXSupplierEquipmentManagementModelMessage];
    self.success = [aDecoder decodeBoolForKey:kHKXSupplierEquipmentManagementModelSuccess];
    self.data = [aDecoder decodeObjectForKey:kHKXSupplierEquipmentManagementModelData];
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{

    [aCoder encodeObject:_message forKey:kHKXSupplierEquipmentManagementModelMessage];
    [aCoder encodeBool:_success forKey:kHKXSupplierEquipmentManagementModelSuccess];
    [aCoder encodeObject:_data forKey:kHKXSupplierEquipmentManagementModelData];
}

- (id)copyWithZone:(NSZone *)zone
{
    HKXSupplierEquipmentManagementModel *copy = [[HKXSupplierEquipmentManagementModel alloc] init];
    
    if (copy) {

        copy.message = [self.message copyWithZone:zone];
        copy.success = self.success;
        copy.data = [self.data copyWithZone:zone];
    }
    
    return copy;
}


@end
