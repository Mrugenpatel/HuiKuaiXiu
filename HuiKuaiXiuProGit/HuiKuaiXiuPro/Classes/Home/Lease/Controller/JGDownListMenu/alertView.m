//
//  alertView.m
//  HuiKuaiXiuPro
//
//  Created by daemona on 2017/7/20.
//  Copyright © 2017年 Lee. All rights reserved.
//

#import "alertView.h"

@implementation alertView

- (instancetype)initWithFrame:(CGRect)frame{
    
    if (self = [super initWithFrame:frame]) {
        
        self.bgView = [[UIView alloc] init];
        [self addSubview:self.bgView];
        self.showView = [[UIView alloc] init];
        [self.bgView addSubview:self.showView];
        self.msgLb = [[UILabel alloc] init];
        [self.showView addSubview:self.msgLb];
        self.certainBtn = [[UIButton alloc] init];
        [self.showView addSubview:self.certainBtn];
    }
    return self;
}
- (void)layoutSubviews{
    
    [super layoutSubviews];
    
//    CGFloat width = self.bounds.size.width;
//    CGFloat height = self.bounds.size.height;
//    NSDictionary *attrs = @{NSFontAttributeName : [UIFont boldSystemFontOfSize:17]};
//    CGSize size=[self.label.text sizeWithAttributes:attrs];
    
    self.bgView.frame = CGRectMake(0, 0, ScreenWidth, ScreenHeight);
    //设置背景半透明
    self.bgView.backgroundColor = [UIColor colorWithWhite:0.f alpha:0.5];
    self.showView.frame = CGRectMake(40,self.frame.size.height / 3, ScreenWidth - 80, ScreenHeight / 4);
    self.showView.backgroundColor = [UIColor whiteColor];
    self.showView.layer.cornerRadius = 5.0f;
    self.showView.layer.masksToBounds = YES;
    self.msgLb.frame = CGRectMake(55, 10, self.showView.frame.size.width - 110, self.showView.frame.size.height/2);
    self.msgLb.lineBreakMode = NSLineBreakByWordWrapping;
    self.msgLb.numberOfLines = 0;
    self.msgLb.textAlignment = NSTextAlignmentCenter;
    NSMutableParagraphStyle  *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    // 行间距设置为30
    [paragraphStyle  setLineSpacing:15];
    NSMutableAttributedString  *setString = [[NSMutableAttributedString alloc] initWithString:self.msgLb.text];
    [setString  addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [self.msgLb.text length])];

    self.msgLb.font = [UIFont systemFontOfSize:20];
    self.certainBtn.frame = CGRectMake(self.msgLb.frame.origin.x,10 + self.msgLb.frame.size.height + 10, self.msgLb.frame.size.width, self.msgLb.frame.size.height / 3 * 2);
    self.certainBtn.layer.cornerRadius = 5.0f;
    self.certainBtn.layer.masksToBounds = YES;
    [self.certainBtn setTitle:@"确定" forState:UIControlStateNormal];
    [self.certainBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.certainBtn setBackgroundColor:[UIColor orangeColor]];
    
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
