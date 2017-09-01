//
//  HKXMineAddressListModel.m
//
//  Created by   on 2017/9/1
//  Copyright (c) 2017 __MyCompanyName__. All rights reserved.
//

#import "HKXMineAddressListModel.h"
#import "HKXMineAddressListData.h"


NSString *const kHKXMineAddressListModelMessage = @"message";
NSString *const kHKXMineAddressListModelSuccess = @"success";
NSString *const kHKXMineAddressListModelData = @"data";


@interface HKXMineAddressListModel ()

- (id)objectOrNilForKey:(id)aKey fromDictionary:(NSDictionary *)dict;

@end

@implementation HKXMineAddressListModel

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
            self.message = [self objectOrNilForKey:kHKXMineAddressListModelMessage fromDictionary:dict];
            self.success = [[self objectOrNilForKey:kHKXMineAddressListModelSuccess fromDictionary:dict] boolValue];
    NSObject *receivedHKXMineAddressListData = [dict objectForKey:kHKXMineAddressListModelData];
    NSMutableArray *parsedHKXMineAddressListData = [NSMutableArray array];
    if ([receivedHKXMineAddressListData isKindOfClass:[NSArray class]]) {
        for (NSDictionary *item in (NSArray *)receivedHKXMineAddressListData) {
            if ([item isKindOfClass:[NSDictionary class]]) {
                [parsedHKXMineAddressListData addObject:[HKXMineAddressListData modelObjectWithDictionary:item]];
            }
       }
    } else if ([receivedHKXMineAddressListData isKindOfClass:[NSDictionary class]]) {
       [parsedHKXMineAddressListData addObject:[HKXMineAddressListData modelObjectWithDictionary:(NSDictionary *)receivedHKXMineAddressListData]];
    }

    self.data = [NSArray arrayWithArray:parsedHKXMineAddressListData];

    }
    
    return self;
    
}

- (NSDictionary *)dictionaryRepresentation
{
    NSMutableDictionary *mutableDict = [NSMutableDictionary dictionary];
    [mutableDict setValue:self.message forKey:kHKXMineAddressListModelMessage];
    [mutableDict setValue:[NSNumber numberWithBool:self.success] forKey:kHKXMineAddressListModelSuccess];
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
    [mutableDict setValue:[NSArray arrayWithArray:tempArrayForData] forKey:kHKXMineAddressListModelData];

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

    self.message = [aDecoder decodeObjectForKey:kHKXMineAddressListModelMessage];
    self.success = [aDecoder decodeBoolForKey:kHKXMineAddressListModelSuccess];
    self.data = [aDecoder decodeObjectForKey:kHKXMineAddressListModelData];
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{

    [aCoder encodeObject:_message forKey:kHKXMineAddressListModelMessage];
    [aCoder encodeBool:_success forKey:kHKXMineAddressListModelSuccess];
    [aCoder encodeObject:_data forKey:kHKXMineAddressListModelData];
}

- (id)copyWithZone:(NSZone *)zone
{
    HKXMineAddressListModel *copy = [[HKXMineAddressListModel alloc] init];
    
    if (copy) {

        copy.message = [self.message copyWithZone:zone];
        copy.success = self.success;
        copy.data = [self.data copyWithZone:zone];
    }
    
    return copy;
}


@end
