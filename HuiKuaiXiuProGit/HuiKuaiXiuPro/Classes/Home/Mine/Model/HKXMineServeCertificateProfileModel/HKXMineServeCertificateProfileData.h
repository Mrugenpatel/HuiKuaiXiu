//
//  HKXMineServeCertificateProfileData.h
//
//  Created by   on 2017/7/26
//  Copyright (c) 2017 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>



@interface HKXMineServeCertificateProfileData : NSObject <NSCoding, NSCopying>

@property (nonatomic, copy  ) NSString *majorMachine;
@property (nonatomic, strong) NSArray *credentials;
@property (nonatomic, copy  ) NSString *profile;

+ (instancetype)modelObjectWithDictionary:(NSDictionary *)dict;
- (instancetype)initWithDictionary:(NSDictionary *)dict;
- (NSDictionary *)dictionaryRepresentation;

@end
