//
//  CommonMethod.m
//  HuiKuaiXiuPro
//
//  Created by 李金灿 on 2017/6/27.
//  Copyright © 2017年 Lee. All rights reserved.
//

#import "CommonMethod.h"

@implementation CommonMethod

/**
 *  颜色值 # 转 成RGB的方法
 *
 *  @param colorString 颜色值
 *
 *  @return 可用color
 */
+ (UIColor *)getUsualColorWithString:(NSString *)colorString
{
    
    colorString = [colorString stringByReplacingCharactersInRange:[colorString rangeOfString:@"#"] withString:@"0x"];
    //    16进制字符串转成整形
    long colorLong = strtol([colorString cStringUsingEncoding:NSUTF8StringEncoding], 0, 16);
    //    通过位与方法获取三色值
    int R = (colorLong & 0xFF0000)>>16;
    int G = (colorLong & 0x00FF00)>>8;
    int B = colorLong & 0x0000FF;
    //    string转color
    UIColor * wordColor = [UIColor colorWithRed:R/255.0 green:G/255.0 blue:B/255.0 alpha:1.0];
    return wordColor;
}
/**
 *  传进一个字符串，返回其长度
 *
 *  @param string 字符串
 *
 *  @return 字符串的长度
 */
+ (CGFloat)getLabelLengthWithString:(NSString *)string  WithFont:(float)font
{
    CGRect stringRect = [string boundingRectWithSize:CGSizeMake(MAXFLOAT, font) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:font]} context:nil];
    
    return stringRect.size.width;
}

/**
 根据时间戳获得所需时间显示
 
 @param date 时间戳
 @return 时间
 */
+ (NSString *)getTimeWithTimeSp:(double )date
{
    NSDateFormatter * formatter = [[NSDateFormatter alloc] init];
    NSDate * timeSp = [NSDate dateWithTimeIntervalSince1970:date];
    NSString * confirmTime = [formatter stringFromDate:timeSp];
    return confirmTime;
}
@end
