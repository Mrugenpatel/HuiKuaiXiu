//
//  HKXSupplierPartsManagementModel.m
//
//  Created by   on 2017/7/27
//  Copyright (c) 2017 __MyCompanyName__. All rights reserved.
//

#import "HKXSupplierPartsManagementModel.h"
#import "HKXSupplierPartsManagementData.h"


NSString *const kHKXSupplierPartsManagementModelMessage = @"message";
NSString *const kHKXSupplierPartsManagementModelSuccess = @"success";
NSString *const kHKXSupplierPartsManagementModelData = @"data";


@interface HKXSupplierPartsManagementModel ()

- (id)objectOrNilForKey:(id)aKey fromDictionary:(NSDictionary *)dict;

@end

@implementation HKXSupplierPartsManagementModel

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
            self.message = [self objectOrNilForKey:kHKXSupplierPartsManagementModelMessage fromDictionary:dict];
            self.success = [[self objectOrNilForKey:kHKXSupplierPartsManagementModelSuccess fromDictionary:dict] boolValue];
    NSObject *receivedHKXSupplierPartsManagementData = [dict objectForKey:kHKXSupplierPartsManagementModelData];
    NSMutableArray *parsedHKXSupplierPartsManagementData = [NSMutableArray array];
    if ([receivedHKXSupplierPartsManagementData isKindOfClass:[NSArray class]]) {
        for (NSDictionary *item in (NSArray *)receivedHKXSupplierPartsManagementData) {
            if ([item isKindOfClass:[NSDictionary class]]) {
                [parsedHKXSupplierPartsManagementData addObject:[HKXSupplierPartsManagementData modelObjectWithDictionary:item]];
            }
       }
    } else if ([receivedHKXSupplierPartsManagementData isKindOfClass:[NSDictionary class]]) {
       [parsedHKXSupplierPartsManagementData addObject:[HKXSupplierPartsManagementData modelObjectWithDictionary:(NSDictionary *)receivedHKXSupplierPartsManagementData]];
    }

    self.data = [NSArray arrayWithArray:parsedHKXSupplierPartsManagementData];

    }
    
    return self;
    
}

- (NSDictionary *)dictionaryRepresentation
{
    NSMutableDictionary *mutableDict = [NSMutableDictionary dictionary];
    [mutableDict setValue:self.message forKey:kHKXSupplierPartsManagementModelMessage];
    [mutableDict setValue:[NSNumber numberWithBool:self.success] forKey:kHKXSupplierPartsManagementModelSuccess];
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
    [mutableDict setValue:[NSArray arrayWithArray:tempArrayForData] forKey:kHKXSupplierPartsManagementModelData];

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

    self.message = [aDecoder decodeObjectForKey:kHKXSupplierPartsManagementModelMessage];
    self.success = [aDecoder decodeBoolForKey:kHKXSupplierPartsManagementModelSuccess];
    self.data = [aDecoder decodeObjectForKey:kHKXSupplierPartsManagementModelData];
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{

    [aCoder encodeObject:_message forKey:kHKXSupplierPartsManagementModelMessage];
    [aCoder encodeBool:_success forKey:kHKXSupplierPartsManagementModelSuccess];
    [aCoder encodeObject:_data forKey:kHKXSupplierPartsManagementModelData];
}

- (id)copyWithZone:(NSZone *)zone
{
    HKXSupplierPartsManagementModel *copy = [[HKXSupplierPartsManagementModel alloc] init];
    
    if (copy) {

        copy.message = [self.message copyWithZone:zone];
        copy.success = self.success;
        copy.data = [self.data copyWithZone:zone];
    }
    
    return copy;
}


@end
