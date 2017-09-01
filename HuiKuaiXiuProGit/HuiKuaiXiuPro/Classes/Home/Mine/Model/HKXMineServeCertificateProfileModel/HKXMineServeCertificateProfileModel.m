//
//  HKXMineServeCertificateProfileModel.m
//
//  Created by   on 2017/7/26
//  Copyright (c) 2017 __MyCompanyName__. All rights reserved.
//

#import "HKXMineServeCertificateProfileModel.h"
#import "HKXMineServeCertificateProfileData.h"


NSString *const kHKXMineServeCertificateProfileModelMessage = @"message";
NSString *const kHKXMineServeCertificateProfileModelSuccess = @"success";
NSString *const kHKXMineServeCertificateProfileModelData = @"data";


@interface HKXMineServeCertificateProfileModel ()

- (id)objectOrNilForKey:(id)aKey fromDictionary:(NSDictionary *)dict;

@end

@implementation HKXMineServeCertificateProfileModel

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
            self.message = [self objectOrNilForKey:kHKXMineServeCertificateProfileModelMessage fromDictionary:dict];
            self.success = [[self objectOrNilForKey:kHKXMineServeCertificateProfileModelSuccess fromDictionary:dict] boolValue];
            self.data = [HKXMineServeCertificateProfileData modelObjectWithDictionary:[dict objectForKey:kHKXMineServeCertificateProfileModelData]];

    }
    
    return self;
    
}

- (NSDictionary *)dictionaryRepresentation
{
    NSMutableDictionary *mutableDict = [NSMutableDictionary dictionary];
    [mutableDict setValue:self.message forKey:kHKXMineServeCertificateProfileModelMessage];
    [mutableDict setValue:[NSNumber numberWithBool:self.success] forKey:kHKXMineServeCertificateProfileModelSuccess];
    [mutableDict setValue:[self.data dictionaryRepresentation] forKey:kHKXMineServeCertificateProfileModelData];

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

    self.message = [aDecoder decodeObjectForKey:kHKXMineServeCertificateProfileModelMessage];
    self.success = [aDecoder decodeBoolForKey:kHKXMineServeCertificateProfileModelSuccess];
    self.data = [aDecoder decodeObjectForKey:kHKXMineServeCertificateProfileModelData];
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{

    [aCoder encodeObject:_message forKey:kHKXMineServeCertificateProfileModelMessage];
    [aCoder encodeBool:_success forKey:kHKXMineServeCertificateProfileModelSuccess];
    [aCoder encodeObject:_data forKey:kHKXMineServeCertificateProfileModelData];
}

- (id)copyWithZone:(NSZone *)zone
{
    HKXMineServeCertificateProfileModel *copy = [[HKXMineServeCertificateProfileModel alloc] init];
    
    if (copy) {

        copy.message = [self.message copyWithZone:zone];
        copy.success = self.success;
        copy.data = [self.data copyWithZone:zone];
    }
    
    return copy;
}


@end
