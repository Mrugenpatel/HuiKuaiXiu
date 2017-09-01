//
//  HKXMineServeCertificateProfileData.m
//
//  Created by   on 2017/7/26
//  Copyright (c) 2017 __MyCompanyName__. All rights reserved.
//

#import "HKXMineServeCertificateProfileData.h"


NSString *const kHKXMineServeCertificateProfileDataMajorMachine = @"majorMachine";
NSString *const kHKXMineServeCertificateProfileDataCredentials = @"credentials";
NSString *const kHKXMineServeCertificateProfileDataProfile = @"profile";


@interface HKXMineServeCertificateProfileData ()

- (id)objectOrNilForKey:(id)aKey fromDictionary:(NSDictionary *)dict;

@end

@implementation HKXMineServeCertificateProfileData

@synthesize majorMachine = _majorMachine;
@synthesize credentials = _credentials;
@synthesize profile = _profile;


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
            self.majorMachine = [self objectOrNilForKey:kHKXMineServeCertificateProfileDataMajorMachine fromDictionary:dict];
            self.credentials = [self objectOrNilForKey:kHKXMineServeCertificateProfileDataCredentials fromDictionary:dict];
            self.profile = [self objectOrNilForKey:kHKXMineServeCertificateProfileDataProfile fromDictionary:dict];

    }
    
    return self;
    
}

- (NSDictionary *)dictionaryRepresentation
{
    NSMutableDictionary *mutableDict = [NSMutableDictionary dictionary];
    [mutableDict setValue:self.majorMachine forKey:kHKXMineServeCertificateProfileDataMajorMachine];
    NSMutableArray *tempArrayForCredentials = [NSMutableArray array];
    for (NSObject *subArrayObject in self.credentials) {
        if([subArrayObject respondsToSelector:@selector(dictionaryRepresentation)]) {
            // This class is a model object
            [tempArrayForCredentials addObject:[subArrayObject performSelector:@selector(dictionaryRepresentation)]];
        } else {
            // Generic object
            [tempArrayForCredentials addObject:subArrayObject];
        }
    }
    [mutableDict setValue:[NSArray arrayWithArray:tempArrayForCredentials] forKey:kHKXMineServeCertificateProfileDataCredentials];
    [mutableDict setValue:self.profile forKey:kHKXMineServeCertificateProfileDataProfile];

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

    self.majorMachine = [aDecoder decodeObjectForKey:kHKXMineServeCertificateProfileDataMajorMachine];
    self.credentials = [aDecoder decodeObjectForKey:kHKXMineServeCertificateProfileDataCredentials];
    self.profile = [aDecoder decodeObjectForKey:kHKXMineServeCertificateProfileDataProfile];
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{

    [aCoder encodeObject:_majorMachine forKey:kHKXMineServeCertificateProfileDataMajorMachine];
    [aCoder encodeObject:_credentials forKey:kHKXMineServeCertificateProfileDataCredentials];
    [aCoder encodeObject:_profile forKey:kHKXMineServeCertificateProfileDataProfile];
}

- (id)copyWithZone:(NSZone *)zone
{
    HKXMineServeCertificateProfileData *copy = [[HKXMineServeCertificateProfileData alloc] init];
    
    if (copy) {

        copy.majorMachine = [self.majorMachine copyWithZone:zone];
        copy.credentials = [self.credentials copyWithZone:zone];
        copy.profile = [self.profile copyWithZone:zone];
    }
    
    return copy;
}


@end
