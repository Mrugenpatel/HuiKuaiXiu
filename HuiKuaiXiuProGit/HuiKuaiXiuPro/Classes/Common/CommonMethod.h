//
//  CommonMethod.h
//  HuiKuaiXiuPro
//
//  Created by 李金灿 on 2017/6/27.
//  Copyright © 2017年 Lee. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CommonMethod : NSObject

//颜色值 # 转 成RGB的方法
+ (UIColor *)getUsualColorWithString:(NSString *)colorString;

/**
 *  传进一个字符串，返回其长度
 *
 *  @param string 字符串
 *
 *  @return 字符串的长度
 */
+ (CGFloat)getLabelLengthWithString:(NSString *)string  WithFont:(float)font;

/**
 根据时间戳获得所需时间显示
 
 @param date 时间戳
 @return 时间
 */
+ (NSString *)getTimeWithTimeSp:(double )date;
@end
