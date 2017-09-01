//
//  orderMapViewController.h
//  HuiKuaiXiuPro
//
//  Created by daemona on 2017/8/7.
//  Copyright © 2017年 Lee. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import <MapKit/MapKit.h>

typedef void (^ReturnAdressBlock) (NSString * adress);
@interface orderMapViewController : UIViewController


@property(nonatomic, copy) ReturnAdressBlock returnAdressBlock;

@property(nonatomic ,assign)CLLocationDegrees latitude;//维修人员所在维度

@property(nonatomic ,assign)CLLocationDegrees longitude;//维修人员所在经度

@property(nonatomic ,copy)NSString *mark;

@end
