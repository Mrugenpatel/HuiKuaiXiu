//
//  HKXSeverCollectionViewCell.m
//  HuiKuaiXiuPro
//
//  Created by daemona on 2017/8/25.
//  Copyright © 2017年 Lee. All rights reserved.
//

#import "HKXSeverCollectionViewCell.h"
#import "CommonMethod.h"
@implementation HKXSeverCollectionViewCell
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.imgView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.frame), CGRectGetWidth(self.frame))];
        
        CAShapeLayer *border = [CAShapeLayer layer];
        border.strokeColor = [CommonMethod getUsualColorWithString:@"#a0a0a0"].CGColor;
        border.fillColor = nil;
        border.path = [UIBezierPath bezierPathWithRect:self.imgView.bounds].CGPath;
        border.frame = self.imgView .bounds;
        border.lineWidth = 0.5;
        border.lineCap = @"square";
        border.lineDashPattern = @[@4, @2];
        [self.imgView .layer addSublayer:border];
        [self addSubview:self.imgView];
        
        self.text = [[UILabel alloc]initWithFrame:CGRectMake(5, CGRectGetMaxY(self.imgView.frame), CGRectGetWidth(self.frame)-10, 20)];
        self.text.textAlignment = NSTextAlignmentCenter;
        //[self addSubview:self.text];
        
        _close  = [UIButton buttonWithType:UIButtonTypeCustom];
        UIImage * image = [UIImage imageNamed:@"减号"];
        [_close setImage:image forState:UIControlStateNormal];
        [_close setFrame:CGRectMake(self.frame.size.width - 10, 0, 10, 10)];
        _close.layer.cornerRadius = _close.frame.size.height /2;
        _close.layer.masksToBounds = YES;
        [_close setBackgroundColor:[UIColor redColor]];
        //[_close sizeToFit];
        [_close addTarget:self action:@selector(closeBtn:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_close];
    }
    return self;
}
-(void)closeBtn:(UIButton *)sender{
    if (_delegate && [_delegate respondsToSelector:@selector(moveImageBtnClick:)]) {
        
        [_delegate moveImageBtnClick:self];
        
    }
}




@end
