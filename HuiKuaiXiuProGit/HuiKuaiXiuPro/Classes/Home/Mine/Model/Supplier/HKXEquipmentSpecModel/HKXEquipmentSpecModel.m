//
//  HKXEquipmentSpecModel.m
//
//  Created by   on 2017/7/28
//  Copyright (c) 2017 __MyCompanyName__. All rights reserved.
//

#import "HKXEquipmentSpecModel.h"



NSString *const kHKXEquipmentSpecModelMessage = @"message";
NSString *const kHKXEquipmentSpecModelSuccess = @"success";
NSString *const kHKXEquipmentSpecModelData = @"data";


@interface HKXEquipmentSpecModel ()

- (id)objectOrNilForKey:(id)aKey fromDictionary:(NSDictionary *)dict;

@end

@implementation HKXEquipmentSpecModel

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
            self.message = [self objectOrNilForKey:kHKXEquipmentSpecModelMessage fromDictionary:dict];
            self.success = [[self objectOrNilForKey:kHKXEquipmentSpecModelSuccess fromDictionary:dict] boolValue];
    
        self.data = [self objectOrNilForKey:kHKXEquipmentSpecModelData fromDictionary:dict];

    }
    
    return self;
    
}

- (NSDictionary *)dictionaryRepresentation
{
    NSMutableDictionary *mutableDict = [NSMutableDictionary dictionary];
    [mutableDict setValue:self.message forKey:kHKXEquipmentSpecModelMessage];
    [mutableDict setValue:[NSNumber numberWithBool:self.success] forKey:kHKXEquipmentSpecModelSuccess];
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
    [mutableDict setValue:[NSArray arrayWithArray:tempArrayForData] forKey:kHKXEquipmentSpecModelData];

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

    self.message = [aDecoder decodeObjectForKey:kHKXEquipmentSpecModelMessage];
    self.success = [aDecoder decodeBoolForKey:kHKXEquipmentSpecModelSuccess];
    self.data = [aDecoder decodeObjectForKey:kHKXEquipmentSpecModelData];
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{

    [aCoder encodeObject:_message forKey:kHKXEquipmentSpecModelMessage];
    [aCoder encodeBool:_success forKey:kHKXEquipmentSpecModelSuccess];
    [aCoder encodeObject:_data forKey:kHKXEquipmentSpecModelData];
}

- (id)copyWithZone:(NSZone *)zone
{
    HKXEquipmentSpecModel *copy = [[HKXEquipmentSpecModel alloc] init];
    
    if (copy) {

        copy.message = [self.message copyWithZone:zone];
        copy.success = self.success;
        copy.data = [self.data copyWithZone:zone];
    }
    
    return copy;
}


@end
