//
//  HKXOrderReceivingListTableViewCell.m
//  HuiKuaiXiuPro
//
//  Created by daemona on 2017/9/5.
//  Copyright © 2017年 Lee. All rights reserved.
//

#import "HKXOrderReceivingListTableViewCell.h"

#import "CommonMethod.h"

#import "UIImageView+WebCache.h"

@implementation HKXOrderReceivingListTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
   
    
}
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        self.equipmentNameLabel = [[UILabel alloc] init];
        [self addSubview:self.equipmentNameLabel];
        self.teleLb = [[UILabel alloc] init];
        [self addSubview:self.teleLb];
        self.troubleTypeLabel = [[UILabel alloc] init];
        [self addSubview:self.troubleTypeLabel];
        self.repairTime = [[UILabel alloc] init];
        [self addSubview:self.repairTime];
        self.troubleDescribeLabel = [[UILabel alloc] init];
        [self addSubview:self.troubleDescribeLabel];
        self.troubleDetailLabel = [[UILabel alloc] init];
        [self addSubview:self.troubleDetailLabel];
        self.troublePicLabel = [[UILabel alloc] init];
        [self addSubview:self.troublePicLabel];
        self.troublePicImage = [[UIImageView alloc] init];
        [self addSubview:self.troublePicImage];
        self.addressLabel = [[UILabel alloc] init];
        [self addSubview:self.addressLabel];
        self.addressBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [self addSubview:self.addressBtn];
        self.actionBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [self addSubview:self.actionBtn];
    }
    return self;
}

- (void)setRepairModel:(repairListModel *)repairModel{
    
    _repairModel = repairModel;
    
}

- (void)layoutSubviews{
    
    [self createSubViews];
}

- (void)createSubViews{
    
    
    AppDelegate * myDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(callTele:)];
    //    维修设备
    self.equipmentNameLabel.frame = CGRectMake(22 * myDelegate.autoSizeScaleX, 55 / 2 * myDelegate.autoSizeScaleY, ScreenWidth - 44 * myDelegate.autoSizeScaleX, 17 * myDelegate.autoSizeScaleX);
    self.equipmentNameLabel.tag = 4000;
    self.equipmentNameLabel.text = [NSString stringWithFormat:@"维修设备：%@",self.repairModel.brandModel];
    self.equipmentNameLabel.font = [UIFont systemFontOfSize:17 * myDelegate.autoSizeScaleX];
    
    //机主电话
        if ([self.repairModel.repairStatus doubleValue] != 2) {
        
        self.teleLb.frame= CGRectMake(22 * myDelegate.autoSizeScaleX,CGRectGetMaxY(self.equipmentNameLabel.frame) + 24 * myDelegate.autoSizeScaleY, ScreenWidth - 44 * myDelegate.autoSizeScaleX, 17 * myDelegate.autoSizeScaleX);
        self.troubleTypeLabel.frame=CGRectMake(22 * myDelegate.autoSizeScaleX,CGRectGetMaxY(self.teleLb.frame) + 24 * myDelegate.autoSizeScaleY, ScreenWidth - 44 * myDelegate.autoSizeScaleX, 17 * myDelegate.autoSizeScaleX);
        
    }else{
        
        self.teleLb.frame= CGRectMake(22 * myDelegate.autoSizeScaleX,CGRectGetMaxY(self.equipmentNameLabel.frame) + 24 * myDelegate.autoSizeScaleY, ScreenWidth - 44 * myDelegate.autoSizeScaleX, 0);
        self.troubleTypeLabel.frame=CGRectMake(22 * myDelegate.autoSizeScaleX,CGRectGetMaxY(self.equipmentNameLabel.frame) + 24 * myDelegate.autoSizeScaleY, ScreenWidth - 44 * myDelegate.autoSizeScaleX, 17 * myDelegate.autoSizeScaleX);
    }
    self.teleLb.userInteractionEnabled = YES;
    [self.teleLb addGestureRecognizer:tap];
    self.teleLb.text = [NSString stringWithFormat:@"机主电话：%@",self.repairModel.telephone];
    self.teleLb.font = [UIFont systemFontOfSize:17 * myDelegate.autoSizeScaleX];
    //故障类型
   
    self.troubleTypeLabel.text = [NSString stringWithFormat:@"故障类型：%@",self.repairModel.fault];
    self.troubleTypeLabel.font = [UIFont systemFontOfSize:17 * myDelegate.autoSizeScaleX];
    
    //维修时间
     float titleLabelLength = [CommonMethod getLabelLengthWithString:@"故障描述：" WithFont:17 * myDelegate.autoSizeScaleX];
    if([self.repairModel.appointmentTime isKindOfClass:[NSNull class]] || self.repairModel.appointmentTime.length == 0){
        
        self.repairTime.frame = CGRectMake(22 * myDelegate.autoSizeScaleX,CGRectGetMaxY(self.troubleTypeLabel.frame) + 24 * myDelegate.autoSizeScaleY, ScreenWidth - 44 * myDelegate.autoSizeScaleX,0);
        
        self.troubleDescribeLabel.frame = CGRectMake(22 * myDelegate.autoSizeScaleX,CGRectGetMaxY(self.troubleTypeLabel.frame) + 24 * myDelegate.autoSizeScaleY, titleLabelLength, 17 * myDelegate.autoSizeScaleX);
        
        self.troubleDetailLabel.frame = CGRectMake(CGRectGetMaxX(self.troubleDescribeLabel.frame),CGRectGetMaxY(self.troubleTypeLabel.frame) + 24 * myDelegate.autoSizeScaleY, ScreenWidth - 44 * myDelegate.autoSizeScaleX - titleLabelLength, 48 * myDelegate.autoSizeScaleX);
        
        
    }else{
        
         self.repairTime.frame = CGRectMake(22 * myDelegate.autoSizeScaleX,CGRectGetMaxY(self.troubleTypeLabel.frame) + 24 * myDelegate.autoSizeScaleY, ScreenWidth - 44 * myDelegate.autoSizeScaleX, 17 * myDelegate.autoSizeScaleX);
        
        self.troubleDescribeLabel.frame = CGRectMake(22 * myDelegate.autoSizeScaleX,CGRectGetMaxY(self.repairTime.frame) + 24 * myDelegate.autoSizeScaleY, titleLabelLength, 17 * myDelegate.autoSizeScaleX);
        
        self.troubleDetailLabel.frame = CGRectMake(CGRectGetMaxX(self.troubleDescribeLabel.frame),CGRectGetMaxY(self.repairTime.frame) + 24 * myDelegate.autoSizeScaleY, ScreenWidth - 44 * myDelegate.autoSizeScaleX - titleLabelLength, 48 * myDelegate.autoSizeScaleX);
        
        
    }
    self.repairTime.textColor = [UIColor orangeColor];
    self.repairTime.text = [NSString stringWithFormat:@"维修时间: %@",self.repairModel.appointmentTime];
    NSMutableAttributedString * repairTimeStr =[[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"维修时间: %@",self.repairModel.appointmentTime]];
    NSRange redRange = NSMakeRange(0, [[repairTimeStr string] rangeOfString:@":"].location + 1);
    
    [repairTimeStr addAttribute:NSForegroundColorAttributeName value:[UIColor blackColor] range:redRange];
    [self.repairTime setAttributedText:repairTimeStr];
    self.repairTime.font = [UIFont systemFontOfSize:17 * myDelegate.autoSizeScaleX];

   
    //    故障描述
    
    self.troubleDescribeLabel.text = [NSString stringWithFormat:@"故障描述："];
    self.troubleDescribeLabel.font = [UIFont systemFontOfSize:17 * myDelegate.autoSizeScaleX];
    
    
    
    self.troubleDetailLabel.text = [NSString stringWithFormat:@"%@",self.repairModel.faultInfo];
    self.troubleDetailLabel.numberOfLines = 2;
    self.troubleDetailLabel.font = [UIFont systemFontOfSize:17 * myDelegate.autoSizeScaleX];

    //    故障图片
    self.troublePicLabel.frame = CGRectMake(22 * myDelegate.autoSizeScaleX,CGRectGetMaxY(self.troubleDetailLabel.frame) + 24 * myDelegate.autoSizeScaleY, titleLabelLength, 17 * myDelegate.autoSizeScaleX);
    self.troublePicLabel.text = [NSString stringWithFormat:@"故障图片"];
    self.troublePicLabel.font = [UIFont systemFontOfSize:17 * myDelegate.autoSizeScaleX];
    
    NSString * str = @"1";
    NSInteger o = self.repairModel.picture.count;
    if (self.repairModel.picture.count < 4) {
        
        for (int k = 0; k < (4 - o)
             ; k ++) {
            
            [self.repairModel.picture addObject:str];
        }
    }
    
    for (int i = 0; i < 4; i ++)
    {
        int X = i % 2;
        int Y = i / 2;
        self.troublePicImage.frame = CGRectMake(CGRectGetMaxX(self.troublePicLabel.frame) + (17 + 100 * X) * myDelegate.autoSizeScaleX , CGRectGetMaxY(self.troubleDetailLabel.frame) + (24 + 73 * Y) * myDelegate.autoSizeScaleY, 97 * myDelegate.autoSizeScaleX, 64 * myDelegate.autoSizeScaleY);
        
        [self.troublePicImage sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",kIMAGEURL,self.repairModel.picture[i]]] placeholderImage:[UIImage imageNamed:@""]];
        [self addSubview:self.troublePicImage];
        
        if (i == 2)
        {
            //            地址
            self.addressLabel.frame = CGRectMake(22 * myDelegate.autoSizeScaleX,CGRectGetMaxY(self.troublePicImage.frame) + 17 * myDelegate.autoSizeScaleY, ScreenWidth - 78 * myDelegate.autoSizeScaleX, 17 * myDelegate.autoSizeScaleX);
            self.addressLabel.tag = 4009;
            self.addressLabel.text = [NSString stringWithFormat:@"地址：%@",self.repairModel.address];
            self.addressLabel.font = [UIFont systemFontOfSize:17 * myDelegate.autoSizeScaleX];
            
            //            定位
            
            self.addressBtn.tag = self.tag;
            self.addressBtn.frame = CGRectMake(CGRectGetMaxX(self.addressLabel.frame) + 19 * myDelegate.autoSizeScaleX, self.addressLabel.frame.origin.y - 2.5 * myDelegate.autoSizeScaleY, 15 * myDelegate.autoSizeScaleX, 22 * myDelegate.autoSizeScaleY);
            [self.addressBtn setImage:[UIImage imageNamed:@"定位"] forState:UIControlStateNormal];
            [self.addressBtn addTarget:self action:@selector(showMapAddressBtnClick:) forControlEvents:UIControlEventTouchUpInside];
            
            //            抢单按钮
            
            self.actionBtn.tag = self.tag + 1000;
            self.actionBtn.frame = CGRectMake(203 * myDelegate.autoSizeScaleX, CGRectGetMaxY(self.addressLabel.frame) + 19 * myDelegate.autoSizeScaleY, 150 * myDelegate.autoSizeScaleX, 44 * myDelegate.autoSizeScaleY);
            [self.actionBtn setBackgroundColor:[CommonMethod getUsualColorWithString:@"#ffa304"]];
            [self.actionBtn setTitle:self.repairModel.repairexplain forState:UIControlStateNormal];
            [self.actionBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [self.actionBtn addTarget:self action:@selector(orderStateBtnClick:) forControlEvents:UIControlEventTouchUpInside];
            self.actionBtn.layer.cornerRadius = 2;
            self.actionBtn.clipsToBounds = YES;
        }
    
    }
}

-(void)callTele:(UITapGestureRecognizer *)tap{
    
    if (self.CallTeleBlock) {
        
        self.CallTeleBlock(tap);
    }
    
}

-(void)showMapAddressBtnClick:(UIButton *)adressBtn{
    
    if (self.BtnClickBlock) {
        
        self.BtnClickBlock(adressBtn);
    }
    
}

-(void)orderStateBtnClick:(UIButton *)action{
    
    if (self.BtnClickBlock) {
        
        self.BtnClickBlock(action);
    }
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
