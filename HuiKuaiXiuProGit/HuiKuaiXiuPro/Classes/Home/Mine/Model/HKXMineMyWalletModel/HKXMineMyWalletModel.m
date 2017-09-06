//
//  HKXMineMyWalletModel.m
//
//  Created by   on 2017/9/5
//  Copyright (c) 2017 __MyCompanyName__. All rights reserved.
//

#import "HKXMineMyWalletModel.h"
#import "HKXMineMyWalletData.h"


NSString *const kHKXMineMyWalletModelMessage = @"message";
NSString *const kHKXMineMyWalletModelSuccess = @"success";
NSString *const kHKXMineMyWalletModelData = @"data";


@interface HKXMineMyWalletModel ()

- (id)objectOrNilForKey:(id)aKey fromDictionary:(NSDictionary *)dict;

@end

@implementation HKXMineMyWalletModel

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
            self.message = [self objectOrNilForKey:kHKXMineMyWalletModelMessage fromDictionary:dict];
            self.success = [[self objectOrNilForKey:kHKXMineMyWalletModelSuccess fromDictionary:dict] boolValue];
    NSObject *receivedHKXMineMyWalletData = [dict objectForKey:kHKXMineMyWalletModelData];
    NSMutableArray *parsedHKXMineMyWalletData = [NSMutableArray array];
    if ([receivedHKXMineMyWalletData isKindOfClass:[NSArray class]]) {
        for (NSDictionary *item in (NSArray *)receivedHKXMineMyWalletData) {
            if ([item isKindOfClass:[NSDictionary class]]) {
                [parsedHKXMineMyWalletData addObject:[HKXMineMyWalletData modelObjectWithDictionary:item]];
            }
       }
    } else if ([receivedHKXMineMyWalletData isKindOfClass:[NSDictionary class]]) {
       [parsedHKXMineMyWalletData addObject:[HKXMineMyWalletData modelObjectWithDictionary:(NSDictionary *)receivedHKXMineMyWalletData]];
    }

    self.data = [NSArray arrayWithArray:parsedHKXMineMyWalletData];

    }
    
    return self;
    
}

- (NSDictionary *)dictionaryRepresentation
{
    NSMutableDictionary *mutableDict = [NSMutableDictionary dictionary];
    [mutableDict setValue:self.message forKey:kHKXMineMyWalletModelMessage];
    [mutableDict setValue:[NSNumber numberWithBool:self.success] forKey:kHKXMineMyWalletModelSuccess];
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
    [mutableDict setValue:[NSArray arrayWithArray:tempArrayForData] forKey:kHKXMineMyWalletModelData];

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

    self.message = [aDecoder decodeObjectForKey:kHKXMineMyWalletModelMessage];
    self.success = [aDecoder decodeBoolForKey:kHKXMineMyWalletModelSuccess];
    self.data = [aDecoder decodeObjectForKey:kHKXMineMyWalletModelData];
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{

    [aCoder encodeObject:_message forKey:kHKXMineMyWalletModelMessage];
    [aCoder encodeBool:_success forKey:kHKXMineMyWalletModelSuccess];
    [aCoder encodeObject:_data forKey:kHKXMineMyWalletModelData];
}

- (id)copyWithZone:(NSZone *)zone
{
    HKXMineMyWalletModel *copy = [[HKXMineMyWalletModel alloc] init];
    
    if (copy) {

        copy.message = [self.message copyWithZone:zone];
        copy.success = self.success;
        copy.data = [self.data copyWithZone:zone];
    }
    
    return copy;
}


@end
