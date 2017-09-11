//
//  HKXOrderReceivingListTableViewCell.h
//  HuiKuaiXiuPro
//
//  Created by daemona on 2017/9/5.
//  Copyright © 2017年 Lee. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "repairListModel.h"

typedef void (^CallTeleBlock) (UIGestureRecognizer * tap);

typedef void (^BtnClickBlock) (UIButton * btn);

@interface HKXOrderReceivingListTableViewCell : UITableViewCell

@property(nonatomic, copy) CallTeleBlock CallTeleBlock;
@property(nonatomic, copy) BtnClickBlock BtnClickBlock;

////机主电话
//UILabel * teleLb = [[UILabel alloc] init];
////故障类型
//UILabel * troubleTypeLabel = [[UILabel alloc] init];
//if ([model.repairStatus doubleValue] != 2) {
//    teleLb.frame= CGRectMake(22 * myDelegate.autoSizeScaleX,CGRectGetMaxY(equipmentNameLabel.frame) + 24 * myDelegate.autoSizeScaleY, ScreenWidth - 44 * myDelegate.autoSizeScaleX, 17 * myDelegate.autoSizeScaleX);
//    teleLb.tag = 399 + indexPath.row;
//    teleLb.userInteractionEnabled = YES;
//    [teleLb addGestureRecognizer:tap];
//    teleLb.text = [NSString stringWithFormat:@"机主电话：%@",model.telephone];
//    teleLb.font = [UIFont systemFontOfSize:17 * myDelegate.autoSizeScaleX];
//    [cell1 addSubview:teleLb];
//    troubleTypeLabel.frame = CGRectMake(22 * myDelegate.autoSizeScaleX,CGRectGetMaxY(teleLb.frame) + 24 * myDelegate.autoSizeScaleY, ScreenWidth - 44 * myDelegate.autoSizeScaleX, 17 * myDelegate.autoSizeScaleX);
//    
//}else{
//    
//    troubleTypeLabel.frame = CGRectMake(22 * myDelegate.autoSizeScaleX,CGRectGetMaxY(equipmentNameLabel.frame) + 24 * myDelegate.autoSizeScaleY, ScreenWidth - 44 * myDelegate.autoSizeScaleX, 17 * myDelegate.autoSizeScaleX);
//}
//
//
//troubleTypeLabel.tag = 4001;
//troubleTypeLabel.text = [NSString stringWithFormat:@"故障类型：%@",model.fault];
//troubleTypeLabel.font = [UIFont systemFontOfSize:17 * myDelegate.autoSizeScaleX];
//[cell1 addSubview:troubleTypeLabel];
//
//
////   维修时间
//UILabel * repairTime = [[UILabel alloc] initWithFrame:CGRectMake(22 * myDelegate.autoSizeScaleX,CGRectGetMaxY(troubleTypeLabel.frame) + 24 * myDelegate.autoSizeScaleY, ScreenWidth - 44 * myDelegate.autoSizeScaleX, 17 * myDelegate.autoSizeScaleX)];
//repairTime.tag = 4402;
//repairTime.textColor = [UIColor orangeColor];
//repairTime.text = [NSString stringWithFormat:@"维修时间: %@",model.appointmentTime];
//NSMutableAttributedString * repairTimeStr =[[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"维修时间: %@",model.appointmentTime]];
//NSRange redRange = NSMakeRange(0, [[repairTimeStr string] rangeOfString:@":"].location + 1);
//
//[repairTimeStr addAttribute:NSForegroundColorAttributeName value:[UIColor blackColor] range:redRange];
//[repairTime setAttributedText:repairTimeStr];
//repairTime.font = [UIFont systemFontOfSize:17 * myDelegate.autoSizeScaleX];
//[cell1 addSubview:repairTime];
//
//float titleLabelLength = [CommonMethod getLabelLengthWithString:@"故障描述：" WithFont:17 * myDelegate.autoSizeScaleX];
////    故障描述
//UILabel * troubleDescribeLabel = [[UILabel alloc] initWithFrame:CGRectMake(22 * myDelegate.autoSizeScaleX,CGRectGetMaxY(repairTime.frame) + 24 * myDelegate.autoSizeScaleY, titleLabelLength, 17 * myDelegate.autoSizeScaleX)];
//troubleDescribeLabel.tag = 4002;
//troubleDescribeLabel.text = [NSString stringWithFormat:@"故障描述："];
//troubleDescribeLabel.font = [UIFont systemFontOfSize:17 * myDelegate.autoSizeScaleX];
//[cell1 addSubview:troubleDescribeLabel];
//
//UILabel * troubleDetailLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(troubleDescribeLabel.frame),CGRectGetMaxY(repairTime.frame) + 24 * myDelegate.autoSizeScaleY, ScreenWidth - 44 * myDelegate.autoSizeScaleX - titleLabelLength, 48 * myDelegate.autoSizeScaleX)];
//troubleDetailLabel.tag = 4003;
//troubleDetailLabel.text = [NSString stringWithFormat:@"%@",model.faultInfo];
//troubleDetailLabel.numberOfLines = 2;
//troubleDetailLabel.font = [UIFont systemFontOfSize:17 * myDelegate.autoSizeScaleX];
//[cell1 addSubview:troubleDetailLabel];
//
////    故障图片
//UILabel * troublePicLabel = [[UILabel alloc] initWithFrame:CGRectMake(22 * myDelegate.autoSizeScaleX,CGRectGetMaxY(troubleDetailLabel.frame) + 24 * myDelegate.autoSizeScaleY, titleLabelLength, 17 * myDelegate.autoSizeScaleX)];
//troublePicLabel.tag = 4004;
//troublePicLabel.text = [NSString stringWithFormat:@"故障图片"];
//troublePicLabel.font = [UIFont systemFontOfSize:17 * myDelegate.autoSizeScaleX];
//[cell1 addSubview:troublePicLabel];
//NSString * str = @"1";
//NSInteger o = model.picture.count;
//if (model.picture.count < 4) {
//    
//    for (int k = 0; k < (4 - o)
//         ; k ++) {
//        
//        [model.picture addObject:str];
//    }
//}
//for (int i = 0; i < 4; i ++)
//{
//    int X = i % 2;
//    int Y = i / 2;
//    UIImageView * troublePicImage = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(troublePicLabel.frame) + (17 + 100 * X) * myDelegate.autoSizeScaleX , CGRectGetMaxY(troubleDetailLabel.frame) + (24 + 73 * Y) * myDelegate.autoSizeScaleY, 97 * myDelegate.autoSizeScaleX, 64 * myDelegate.autoSizeScaleY)];
//    
//    [troublePicImage sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",kIMAGEURL,model.picture[i]]] placeholderImage:[UIImage imageNamed:@""]];
//    
//    troublePicImage.tag = 4005 + i;
//    [cell1 addSubview:troublePicImage];
//    
//    if (i == 2)
//    {
//        //            地址
//        UILabel * addressLabel = [[UILabel alloc] initWithFrame:CGRectMake(22 * myDelegate.autoSizeScaleX,CGRectGetMaxY(troublePicImage.frame) + 17 * myDelegate.autoSizeScaleY, ScreenWidth - 78 * myDelegate.autoSizeScaleX, 17 * myDelegate.autoSizeScaleX)];
//        addressLabel.tag = 4009;
//        addressLabel.text = [NSString stringWithFormat:@"地址：%@",model.address];
//        addressLabel.font = [UIFont systemFontOfSize:17 * myDelegate.autoSizeScaleX];
//        [cell1 addSubview:addressLabel];
//        
//        //            定位
//        UIButton * addressBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//        addressBtn.tag = 4010 + indexPath.row;
//        addressBtn.frame = CGRectMake(CGRectGetMaxX(addressLabel.frame) + 19 * myDelegate.autoSizeScaleX, addressLabel.frame.origin.y - 2.5 * myDelegate.autoSizeScaleY, 15 * myDelegate.autoSizeScaleX, 22 * myDelegate.autoSizeScaleY);
//        [addressBtn setImage:[UIImage imageNamed:@"定位"] forState:UIControlStateNormal];
//        [addressBtn addTarget:self action:@selector(showMapAddressBtnClick:) forControlEvents:UIControlEventTouchUpInside];
//        [cell1 addSubview:addressBtn];
//        
//        //            抢单按钮
//        UIButton * actionBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//        actionBtn.tag = 4011 + indexPath.row;
//        actionBtn.frame = CGRectMake(203 * myDelegate.autoSizeScaleX, CGRectGetMaxY(addressLabel.frame) + 19 * myDelegate.autoSizeScaleY, 150 * myDelegate.autoSizeScaleX, 44 * myDelegate.autoSizeScaleY);
//        [actionBtn setBackgroundColor:[CommonMethod getUsualColorWithString:@"#ffa304"]];
//        [actionBtn setTitle:model.repairexplain forState:UIControlStateNormal];
//        [actionBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//        [actionBtn addTarget:self action:@selector(orderStateBtnClick:) forControlEvents:UIControlEventTouchUpInside];
//        actionBtn.layer.cornerRadius = 2;
//        actionBtn.clipsToBounds = YES;
//        [cell1 addSubview:actionBtn];
//    }
//}

@property(nonatomic ,strong)repairListModel *repairModel;
//维修设备
@property(nonatomic ,strong)UILabel *equipmentNameLabel;
//维修时间
@property(nonatomic ,strong)UILabel *timeLabel;
//机主电话
@property(nonatomic ,strong)UILabel *teleLb;
//故障类型
@property(nonatomic ,strong)UILabel *troubleTypeLabel;
//故障类型
@property(nonatomic ,strong)UILabel *troubleTypeDetailLabel;
//维修时间
@property(nonatomic ,strong)UILabel *repairTime;
//故障描述
@property(nonatomic ,strong)UILabel * troubleDescribeLabel;
//描述详情
@property(nonatomic ,strong)UILabel * troubleDetailLabel;
//故障图片
@property(nonatomic ,strong)UILabel * troublePicLabel;
//故障图片
@property(nonatomic ,strong)UIImageView * troublePicImage1;
//故障图片
@property(nonatomic ,strong)UIImageView * troublePicImage2;
//故障图片
@property(nonatomic ,strong)UIImageView * troublePicImage3;
//故障图片
@property(nonatomic ,strong)UIImageView * troublePicImage4;
//地址
@property(nonatomic ,strong)UILabel * addressLabel;
//地图
@property(nonatomic ,strong)UIButton * addressBtn;
//抢单
@property(nonatomic ,strong)UIButton * actionBtn;





@end
