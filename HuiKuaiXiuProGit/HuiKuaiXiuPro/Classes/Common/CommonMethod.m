//
//  CommonMethod.m
//  HuiKuaiXiuPro
//
//  Created by 李金灿 on 2017/6/27.
//  Copyright © 2017年 Lee. All rights reserved.
//

#import "CommonMethod.h"

@implementation CommonMethod

//原始尺寸
static CGRect oldframe;
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


+(void)scanBigImageWithImageView:(UIImageView *)currentImageview{
    //当前imageview的图片
    UIImage *image = currentImageview.image;
    //当前视图
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    //背景
    UIView *backgroundView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)];
    //当前imageview的原始尺寸->将像素currentImageview.bounds由currentImageview.bounds所在视图转换到目标视图window中，返回在目标视图window中的像素值
    oldframe = [currentImageview convertRect:currentImageview.bounds toView:window];
    [backgroundView setBackgroundColor:[UIColor whiteColor]];
    //此时视图不会显示
    [backgroundView setAlpha:0];
    //将所展示的imageView重新绘制在Window中
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:oldframe];
    [imageView setImage:image];
    [imageView setTag:0];
    [backgroundView addSubview:imageView];
    //将原始视图添加到背景视图中
    [window addSubview:backgroundView];
    
    
    //添加点击事件同样是类方法 -> 作用是再次点击回到初始大小
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideImageView:)];
    [backgroundView addGestureRecognizer:tapGestureRecognizer];
    
    //动画放大所展示的ImageView
    
    [UIView animateWithDuration:0.4 animations:^{
        CGFloat y,width,height;
        y = ([UIScreen mainScreen].bounds.size.height - image.size.height * [UIScreen mainScreen].bounds.size.width / image.size.width) * 0.5;
        //宽度为屏幕宽度
        width = [UIScreen mainScreen].bounds.size.width;
        //高度 根据图片宽高比设置
        height = image.size.height * [UIScreen mainScreen].bounds.size.width / image.size.width;
        [imageView setFrame:CGRectMake(0, y, width, height)];
        //重要！ 将视图显示出来
        [backgroundView setAlpha:1];
    } completion:^(BOOL finished) {
        
    }];
    
}

/**
 *  恢复imageView原始尺寸
 *
 *  @param tap 点击事件
 */
+(void)hideImageView:(UITapGestureRecognizer *)tap{
    UIView *backgroundView = tap.view;
    //原始imageview
    UIImageView *imageView = [tap.view viewWithTag:0];
    //恢复
    [UIView animateWithDuration:0.4 animations:^{
        [imageView setFrame:oldframe];
        [backgroundView setAlpha:0];
    } completion:^(BOOL finished) {
        //完成后操作->将背景视图删掉
        [backgroundView removeFromSuperview];
    }];
}

@end
