//
//  issueLeaseViewController.m
//  HuiKuaiXiuPro
//
//  Created by daemona on 2017/7/19.
//  Copyright © 2017年 Lee. All rights reserved.
//

#import "equipmentDetailViewController.h"
#import "myview.h"
#import "alertView.h"
#import "JGDownListMenu.h"
#import "CommonMethod.h"
#import "HKXSeverCollectionViewCell.h"
#import "UIImageView+WebCache.h"
@interface equipmentDetailViewController (){
    
    UIButton * brandButton;//选择设备品牌
    UITextField * siteTextfield;//选择设备所在地
    myview * myView1;//油
    myview * myView2;//司机
    UITextField * costField;//台班费
    UITextField * phoneNumField;//机主电话
    UIButton * pictureBtn;//选择照片按钮
 
}

@end

@implementation equipmentDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.title = @"出租详情";
    self.navigationController.navigationBar.backgroundColor = [UIColor orangeColor];
    
    _brandmodel = [self nullToNil:_brandmodel];
    _address = [self nullToNil:_address];
    _machinephone = [self nullToNil:_machinephone];
    _cost = [self nullToNil:_cost];
    [self createUI];

}
- (NSString *)nullToNil:(NSString *)str{
    
    if ([str isKindOfClass:[NSNull class]]) {
        
        str = @"";
    }
    return str;
}
- (void)createUI{
    
    
    AppDelegate * myDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    UIView * view = [[UIView alloc] initWithFrame:CGRectMake(0, 64, ScreenWidth, 5)];
    view.backgroundColor = [CommonMethod getUsualColorWithString:@"#f6f6f6"];
    [self.view addSubview:view];
    brandButton = [UIButton buttonWithType:UIButtonTypeCustom];
    brandButton.frame = CGRectMake(20, view.frame.origin.y + view.frame.size.height + 10, ScreenWidth - 40, 44 * myDelegate.autoSizeScaleY);
    [brandButton setTitle:[NSString stringWithFormat:@"设备型号:%@",_brandmodel] forState:UIControlStateNormal];
    brandButton.titleLabel.font = [UIFont systemFontOfSize:17];
    [brandButton.layer setBorderColor:[UIColor lightGrayColor].CGColor];
    [brandButton.layer setBorderWidth:1];
    brandButton.clipsToBounds=YES;
    brandButton.layer.cornerRadius=4;
    brandButton.userInteractionEnabled = NO;
    [brandButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    //[brandButton setImage:[UIImage imageNamed:@"箭头"] forState:UIControlStateNormal];
    brandButton.backgroundColor = [UIColor whiteColor];
    brandButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [brandButton setTitleEdgeInsets:UIEdgeInsetsMake(0, - brandButton.imageView.frame.size.width + 10, 0 ,0)];
    [brandButton setImageEdgeInsets:UIEdgeInsetsMake(0,brandButton.frame.size.width - brandButton.imageView.frame.size.width - 10 , 0, 0)];
    
    
    [self.view addSubview:brandButton];
    
    
    siteTextfield = [[UITextField alloc] init];
    siteTextfield.frame = CGRectMake(brandButton.frame.origin.x, brandButton.frame.origin.y + brandButton.frame.size.height + 10, brandButton.frame.size.width, 44 * myDelegate.autoSizeScaleY);
    [siteTextfield.layer setBorderColor:[UIColor lightGrayColor].CGColor];
    [siteTextfield.layer setBorderWidth:1];
    siteTextfield.clipsToBounds=YES;
    siteTextfield.layer.cornerRadius=4;
    
    UIView * lefView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, siteTextfield.frame.size.height)];
    siteTextfield.leftView = lefView;
    siteTextfield.leftViewMode=UITextFieldViewModeAlways;
    siteTextfield.text = [NSString stringWithFormat:@"设备地址:%@",_address];
    //[siteButton setImage:[UIImage imageNamed:@"箭头"] forState:UIControlStateNormal];
    siteTextfield.backgroundColor = [UIColor whiteColor];
    siteTextfield.userInteractionEnabled = NO;
    [self.view addSubview:siteTextfield];
    
    
    myView1 = [[myview alloc] initWithFrame:CGRectMake(brandButton.frame.origin.x, siteTextfield.frame.origin.y + siteTextfield.frame.size.height, brandButton.frame.size.width, 44 * myDelegate.autoSizeScaleY)];
    myView1.label.text = @"是否含油";
    myView1.label.backgroundColor = [UIColor whiteColor];
    if ([[NSString stringWithFormat:@"%@",_oil]isEqualToString:@"1"]) {
        
        myView1.yesBtn.selected = YES;
        myView1.noBtn.selected = NO;
    }else{
        
        myView1.yesBtn.selected = NO;
        myView1.noBtn.selected = YES;
    }
    [myView1.yesBtn setTitle:@"是" forState:UIControlStateNormal];
    [myView1.noBtn setTitle:@"否" forState:UIControlStateNormal];
    myView1.yesBtn.userInteractionEnabled = NO;
    myView1.noBtn.userInteractionEnabled = NO;
    [myView1.yesBtn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    [myView1.yesBtn setTitleColor:[CommonMethod getUsualColorWithString:@"#ffa304"] forState:UIControlStateSelected];
    [myView1.noBtn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    [myView1.noBtn setTitleColor:[CommonMethod getUsualColorWithString:@"#ffa304"] forState:UIControlStateSelected];
    [self.view addSubview:myView1];
    
    myView2 = [[myview alloc] initWithFrame:CGRectMake(brandButton.frame.origin.x, myView1.frame.origin.y + myView1.frame.size.height, brandButton.frame.size.width, 44 * myDelegate.autoSizeScaleY)];
    myView2.label.text = @"是否带司机";
    myView2.label.backgroundColor = [UIColor whiteColor];
    if ([[NSString stringWithFormat:@"%@",_driver] isEqualToString:@"1"]) {
        
        myView2.yesBtn.selected = YES;
        myView2.noBtn.selected = NO;
    }else{
        
        myView2.yesBtn.selected = NO;
        myView2.noBtn.selected = YES;
    }
    [myView2.yesBtn setTitle:@"是" forState:UIControlStateNormal];
    [myView2.noBtn setTitle:@"否" forState:UIControlStateNormal];
    [myView2.yesBtn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    [myView2.yesBtn setTitleColor:[CommonMethod getUsualColorWithString:@"#ffa304"]  forState:UIControlStateSelected];
    [myView2.noBtn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    [myView2.noBtn setTitleColor:[CommonMethod getUsualColorWithString:@"#ffa304"] forState:UIControlStateSelected];
    myView2.yesBtn.userInteractionEnabled = NO;
    myView2.noBtn.userInteractionEnabled = NO;
    [self.view addSubview:myView2];
    
    costField = [[UITextField alloc] initWithFrame:CGRectMake(brandButton.frame.origin.x, myView2.frame.origin.y + myView2.frame.size.height + 10 * myDelegate.autoSizeScaleY, brandButton.frame.size.width, 44 * myDelegate.autoSizeScaleY)];
    costField.borderStyle = UITextBorderStyleLine;
    costField.clearButtonMode = UITextFieldViewModeWhileEditing;
    
    //  costField.layer.cornerRadius=8.0f;
    //  costField.layer.masksToBounds=YES;
    costField.layer.borderColor=[[UIColor lightGrayColor]CGColor];
    costField.layer.borderWidth= 1.0f;
    costField.placeholder = @"台班费";
    costField.text = [NSString stringWithFormat:@"台班费:%@",_cost];
    costField.keyboardType = UIKeyboardTypeNumberPad;
    costField.layer.cornerRadius = 5;
    costField.layer.masksToBounds = YES;
    UIView * leView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, costField.frame.size.height)];
    costField.leftView=leView;
    costField.leftViewMode=UITextFieldViewModeAlways; //此处用来设置leftview现实时机
    costField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    costField.userInteractionEnabled = NO;
    [self.view addSubview:costField];
    
    phoneNumField = [[UITextField alloc] initWithFrame:CGRectMake(brandButton.frame.origin.x, costField.frame.origin.y + costField.frame.size.height + 10 * myDelegate.autoSizeScaleY, brandButton.frame.size.width, 44 * myDelegate.autoSizeScaleY)];
    phoneNumField.text = [NSString stringWithFormat:@"联系人电话:%@",_machinephone];
    phoneNumField.keyboardType = UIKeyboardTypeNumberPad;
    phoneNumField.layer.borderColor=[[UIColor lightGrayColor]CGColor];
    phoneNumField.layer.borderWidth= 1.0f;
    phoneNumField.layer.cornerRadius = 5;
    phoneNumField.layer.masksToBounds = YES;
    UIView * leView1 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, phoneNumField.frame.size.height)];
    phoneNumField.leftView=leView1;
    phoneNumField.leftViewMode=UITextFieldViewModeAlways; //此处用来设置leftview现实时机
    phoneNumField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    phoneNumField.userInteractionEnabled = NO;
    [self.view addSubview:phoneNumField];
    
    CGFloat length = [CommonMethod getLabelLengthWithString:@"照片片" WithFont:15];
    UILabel * pictureLb = [[UILabel alloc] initWithFrame:CGRectMake(brandButton.frame.origin.x, phoneNumField.frame.origin.y + phoneNumField.frame.size.height + 10 * myDelegate.autoSizeScaleY, length, 44 * myDelegate.autoSizeScaleY)];
    pictureLb.font = [UIFont systemFontOfSize:15];
    pictureLb.text = @"照片";
    [self.view addSubview:pictureLb];
    
    UICollectionViewFlowLayout *flowLayout=[[UICollectionViewFlowLayout alloc] init];
    self.collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(CGRectGetMaxX(pictureLb.frame) + 5 * myDelegate.autoSizeScaleX, CGRectGetMaxY(phoneNumField.frame) + 23 * myDelegate.autoSizeScaleY ,ScreenWidth - pictureLb.frame.origin.x - pictureLb.frame.size.width - 5 * myDelegate.autoSizeScaleX, 90 * myDelegate.autoSizeScaleY * 2) collectionViewLayout:flowLayout];
    //设置代理
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    [self.view addSubview:self.collectionView];
    self.collectionView.backgroundColor = [UIColor whiteColor];
    //注册cell和ReusableView（相当于头部）
    [self.collectionView registerClass:[HKXSeverCollectionViewCell class] forCellWithReuseIdentifier:@"cell"];
    
    UIButton * cancleBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    cancleBtn.frame = CGRectMake(brandButton.frame.origin.x, ScreenHeight - 70, ScreenWidth / 2 - brandButton.frame.origin.x * 2, 44 * myDelegate.autoSizeScaleY);
    [cancleBtn setTitle:@"取消" forState:UIControlStateNormal];
    [cancleBtn setBackgroundColor:[UIColor brownColor]];
    cancleBtn.clipsToBounds=YES;
    cancleBtn.layer.cornerRadius=4;
    [cancleBtn addTarget:self action:@selector(cancleClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:cancleBtn];
    
    UIButton * Connect = [UIButton buttonWithType:UIButtonTypeCustom];
    Connect.frame = CGRectMake(ScreenWidth / 2 +  brandButton.frame.origin.x, ScreenHeight - 70, cancleBtn.frame.size.width, cancleBtn.frame.size.height);
    [Connect setTitle:@"立即联系" forState:UIControlStateNormal];
    [Connect setBackgroundColor:[CommonMethod getUsualColorWithString:@"#ffa304"]];
    Connect.clipsToBounds=YES;
    Connect.layer.cornerRadius=4;
    [Connect addTarget:self action:@selector(immediatelyConnect:) forControlEvents:UIControlEventTouchUpInside];
    if ([self.mark isEqualToString:@"我的出租"]) {
        
        
    }else{
        
        [self.view addSubview:Connect];
    }
   
    
}



-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    NSArray * arr = [_picture componentsSeparatedByString:@"$"];
    return arr.count;
    
}
//定义展示的Section的个数
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}
//每个UICollectionView展示的内容
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identify = @"cell";
    HKXSeverCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identify forIndexPath:indexPath];
    [cell sizeToFit];
    if (!cell) {
        NSLog(@"无法创建CollectionViewCell时打印，自定义的cell就不可能进来了。");
    }
    
    NSArray * arr = [_picture componentsSeparatedByString:@"$"];
   
    [cell.imgView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",kIMAGEURL,arr[indexPath.row]]] placeholderImage:[UIImage imageNamed:@"滑动视图示例"]];
    cell.close.hidden = YES;

    return cell;
}
#pragma mark --UICollectionViewDelegateFlowLayout
//定义每个UICollectionView 的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    //边距占5*4=20 ，2个
    //图片为正方形，边长：(fDeviceWidth-20)/2-5-5 所以总高(fDeviceWidth-20)/2-5-5 +20+30+5+5 label高20 btn高30 边
    AppDelegate * myDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    // 2 * 97 * myDelegate.autoSizeScaleX, 3 * 61 * myDelegate.autoSizeScaleY
    
    
    return CGSizeMake( 80 * myDelegate.autoSizeScaleX, 44 * myDelegate.autoSizeScaleY);
}
//定义每个UICollectionView 的间距
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(0, 0, 5, 5);
}
//定义每个UICollectionView 纵向的间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    
    return 5;
}
#pragma mark --UICollectionViewDelegate
//UICollectionView被选中时调用的方法
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    //        UICollectionViewCell * cell = (UICollectionViewCell *)[collectionView cellForItemAtIndexPath:indexPath];
    //        cell.backgroundColor = [UIColor redColor];
    HKXSeverCollectionViewCell * cell = (HKXSeverCollectionViewCell *)[collectionView cellForItemAtIndexPath:indexPath];

   [CommonMethod scanBigImageWithImageView:cell.imgView];

    NSLog(@"选择%ld",indexPath.row);
}
//返回这个UICollectionView是否可以被选择
-(BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    return YES;
}

- (void)cancleClick:(UIButton *)btn{
    
    NSLog(@"取消按钮");
    [self.navigationController popToRootViewControllerAnimated:YES];
}
//立即联系
- (void)immediatelyConnect:(UIButton *)btn{
    
    NSMutableString * str=[[NSMutableString alloc] initWithFormat:@"telprompt://%@",_machinephone];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
    [self.view endEditing:YES];
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
