//
//  Mypoint.m
//  HuiKuaiXiuPro
//
//  Created by daemona on 2017/8/1.
//  Copyright © 2017年 Lee. All rights reserved.
//

#import "Mypoint.h"

@implementation Mypoint

- (id)initWithCoordinate:(CLLocationCoordinate2D)c andTitle:(NSString *)t{
    
    self =[super init];
    if (self) {
        
        _coordinate = c;
        _title = t;
    }
    return self;
}

@end
