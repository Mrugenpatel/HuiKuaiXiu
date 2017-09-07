//
//  HKXMineViewController.m
//  HuiKuaiXiuPro
//
//  Created by 李金灿 on 2017/6/29.
//  Copyright © 2017年 Lee. All rights reserved.
//

#import "HKXMineViewController.h"
#import "CommonMethod.h"
#import "ViewController.h"
#import "HKXLoginData.h"
 #import <SDWebImage/UIButton+WebCache.h>

#import "HKXSupplierReleasePartsViewController.h"//发布配件
#import "HKXSupplierReleaseEquipmentViewController.h"//发布设备
#import "HKXSupplierPartsAndEquipmentManagmentViewController.h"//配件管理/设备管理

#import "HKXMineServeCertificateProfileViewController.h"//证书资料

#import "HKXMineOwnerRepairListViewController.h"//机主报修设备列表
#import "HKXMineServerOrderListViewController.h"//服务人员订单列表
#import "HKXMineSupplierAskValueListViewController.h"//设备询价列表

#import "HKXMineMyWalletViewController.h"//我的钱包界面
#import "HKXMineShoppingCartViewController.h"//购物车
#import "HKXMineBuyingListViewController.h"//买入订单
#import "HKXMineSaleListViewController.h"//卖出订单

#import "HKXMineOwnerEquipmentListViewController.h"//我的设备列表

#import "HKXMineReceiveAddressViewController.h"//收货地址列表



#import "HKXHttpRequestManager.h"
#import "HKXMineOwnerInfoModelDataModels.h"
#import "HKXMineSupplierInfoModelDataModels.h"
#import "HKXMineServeInfoModelDataModels.h"
#import "HKXUserVertificationCodeResultModelDataModels.h"//修改头像结果



#import "CustomSubmitView.h"

#import "SeverMyByLeaseViewController.h"
#import "SupplierMyByLeaseViewController.h"
#import "OwerMyleaseViewController.h"

@interface HKXMineViewController ()<UITableViewDelegate , UITableViewDataSource ,UIImagePickerControllerDelegate , UINavigationControllerDelegate , UIActionSheetDelegate>
{
    NSInteger _roleID;
    long      _userId;
    NSString * _headImagePath;//头像地址
    NSString * _headBase64String;//头像编码后data
    UIButton *rightBtn;
    
    NSString * name;
    NSString * telePhone;
    NSString * adress;
    NSString * company;
    
}

@property (nonatomic , strong) HKXMineOwnerInfoModel * ownerInfoModel;//机主个人信息
@property (nonatomic , strong) HKXMineServeInfoModel * serveInfoModel;//服务维修个人信息
@property (nonatomic , strong) HKXMineSupplierInfoModel * supplierInfoModel;//供应商个人信息

@property (nonatomic , strong) UIActionSheet * actionSheet;

@end

@implementation HKXMineViewController

#pragma mark - LifeCycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
//    NSData * data = [NSData dataWithContentsOfFile:[self getFilePath]];
//    HKXLoginData * userData = [NSKeyedUnarchiver unarchiveObjectWithData:data];

    NSInteger roleId = [[NSUserDefaults standardUserDefaults]integerForKey:@"userDataRole"];
    long userId = [[NSUserDefaults standardUserDefaults] doubleForKey:@"userDataId"];
    _roleID = roleId;
    _userId = userId;
    self.ownerInfoModel = [[HKXMineOwnerInfoModel alloc] init];
    self.serveInfoModel = [[HKXMineServeInfoModel alloc] init];
    self.supplierInfoModel = [[HKXMineSupplierInfoModel alloc] init];
    _headImagePath = [[NSString alloc] init];
    _headBase64String = [[NSString alloc] init];
    
    
    [self createUIWithUserId:_roleID];
    
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBarHidden = NO;
    
    
    [self configData];
    
}
#pragma mark - CreateUI

/**
 根据不同角色id布局不同个人中心界面

 @param userId 角色id（0：机主 1：服务维修 2：供应商）
 */
- (void)createUIWithUserId:(NSInteger)userId
{
    AppDelegate * myDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    self.view.backgroundColor = [UIColor colorWithRed:235 / 255.0 green:235 / 255.0 blue:235 / 255.0 alpha:1];
    
    //    headImage
    float Height = userId == 2 ? 0 : 155 * myDelegate.autoSizeScaleY;
    UIView * headView = [[UIView alloc] initWithFrame:CGRectMake(0 , 60 + 10 * myDelegate.autoSizeScaleY, ScreenWidth, Height)];
    headView.backgroundColor = [UIColor whiteColor];
    headView.tag = 890;
    [self.view addSubview:headView];
    
    rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    rightBtn.frame = CGRectMake(0, 0, 40, 40);
    [rightBtn setTitle:@"编辑" forState:UIControlStateNormal];
    [rightBtn setTitle:@"保存" forState:UIControlStateSelected];
    [rightBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [rightBtn addTarget:self action:@selector(rightBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem * right = [[UIBarButtonItem alloc] initWithCustomView:rightBtn];
    self.navigationItem.rightBarButtonItem = right;
    
    

    UIButton * headImageBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    headImageBtn.frame = CGRectMake((ScreenWidth - 100 * myDelegate.autoSizeScaleX) / 2, 20 * myDelegate.autoSizeScaleY, 100 * myDelegate.autoSizeScaleX, 100 * myDelegate.autoSizeScaleX);
    headImageBtn.layer.cornerRadius = 50 * myDelegate.autoSizeScaleX;
    headImageBtn.clipsToBounds = YES;
    headImageBtn.layer.borderColor = [CommonMethod getUsualColorWithString:@"#ffa304"].CGColor;
    headImageBtn.layer.borderWidth = 2 * myDelegate.autoSizeScaleX;
    headImageBtn.tag = 859;
    [headImageBtn addTarget:self action:@selector(openPhotoLibraryBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [headView addSubview:headImageBtn];
    
    NSString * pointString = @"2000";
    NSString * myPointString = [NSString stringWithFormat:@"我的积分：%@分",pointString];
    
    NSMutableAttributedString * textColor = [[NSMutableAttributedString alloc]initWithString:myPointString];
    NSRange rangel = [[textColor string] rangeOfString:[myPointString substringFromIndex:5]];
    [textColor addAttribute:NSForegroundColorAttributeName value:[CommonMethod getUsualColorWithString:@"#e06e14"] range:rangel];
    [textColor addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:12 * myDelegate.autoSizeScaleX] range:rangel];
    
    UILabel * pointLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(headImageBtn.frame) + 15 * myDelegate.autoSizeScaleY, ScreenWidth, 12 * myDelegate.autoSizeScaleX)];
    pointLabel.font = [UIFont systemFontOfSize:12 * myDelegate.autoSizeScaleX];
    pointLabel.textAlignment = NSTextAlignmentCenter;
    [pointLabel setAttributedText:textColor];
    [headView addSubview:pointLabel];
    
    
//    userInfoTableView
    UITableView * userInfoTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(headView.frame) , ScreenWidth, ScreenHeight - headView.frame.size.height - 60 - 49.5) style:UITableViewStylePlain];
    userInfoTableView.backgroundColor = [UIColor whiteColor];
    userInfoTableView.dataSource = self;
    userInfoTableView.delegate = self;
    userInfoTableView.bounces = NO;
    userInfoTableView.showsVerticalScrollIndicator = NO;
    userInfoTableView.tag = 858;
    [self.view addSubview:userInfoTableView];
    
    [userInfoTableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
}


-(void)rightBtnClick:(UIButton *)rBtn{
    
    rBtn.selected = !rBtn.selected;
    UITableView * userInfoTableView = [self.view viewWithTag:858];
    if (rBtn.selected) {
        
        for (int i = 100;  i < 104;  i ++) {
            
            UITextField * tf = [userInfoTableView viewWithTag:i];
            
            if (i != 101) {
                
               tf.userInteractionEnabled = YES;
            }
            
        }
        
        
    }else{
        
        for (int i = 100;  i < 104;  i ++) {
            
            UITextField * tf = [userInfoTableView viewWithTag:i];
            if (i == 100) {
                
                name = tf.text;
            }else if (i == 101){
                
                telePhone = tf.text;
            }else if (i == 102){
                
                adress = tf.text;
            }else if (i == 104){
                
                company = tf.text;
            }
            tf.userInteractionEnabled = NO;
        }
        
        NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
        double uId = [defaults doubleForKey:@"userDataId"];
        NSDictionary * dict = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithDouble:uId],@"id",name,@"realName",adress,@"address",company,@"companyName",nil];
        NSLog(@"%@",dict);
        
        [self.view showActivity];
        [IWHttpTool postWithUrl:[NSString stringWithFormat:@"%@%@",kBASICURL,@"info/updateUserInfo.do"] params:dict success:^(id responseObject) {
            
            NSDictionary *dicts =[NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
            NSLog(@"请求成功%@",dicts);
            [self.view hideActivity];
            
            if ([dicts[@"success"] boolValue] == YES) {
                
                [self showHint:dicts[@"message"]];
                [self configData];
                
            }else{
                
                [self showHint:dicts[@"message"]];
            }
   
        } failure:^(NSError *error) {
            
            
            [self.view hideActivity];
            [self showHint:@"请求失败"];
            
        }];

    }

}
#pragma mark - ConfigData
- (void)configData
{
    UIView * backView = [self.view viewWithTag:890];
    UIButton * headImageBtn = [backView viewWithTag:859];
    [HKXHttpRequestManager sendRequestWithUserId:[NSString stringWithFormat:@"%ld",_userId] WithUserRole:[NSString stringWithFormat:@"%ld",(long)_roleID] ToGetUserInfoResult:^(id data) {
        
        if (_roleID == 0)
        {
            self.ownerInfoModel = data;
            _headImagePath = self.ownerInfoModel.data.photo;
            
            
            [headImageBtn sd_setBackgroundImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",kIMAGEURL,_headImagePath]] forState:UIControlStateNormal];
        }
        if (_roleID == 1)
        {
            self.serveInfoModel = data;
            _headImagePath = self.serveInfoModel.data.photo;
            [headImageBtn sd_setBackgroundImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",kIMAGEURL,_headImagePath]] forState:UIControlStateNormal];
            
        }
        if (_roleID == 2)
        {
            self.supplierInfoModel = data;
            
        }
        UITableView * userInfoTable = [self.view viewWithTag:858];
        [userInfoTable reloadData];
    }];
}
#pragma mark - Action
- (void)tapGestureClick
{
    for (UIView * view in self.view.subviews)
    {
        if (view.tag == 501 )
        {
            [view removeFromSuperview];
        }
    }
}
- (void)openPhotoLibraryBtnClick
{
    [self callActionSheetFunc];
}
- (void)logoutBtnClick:(UIButton *)btn
{
    
    NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
    double uId = [defaults doubleForKey:@"userDataId"];
    NSArray * arr = [[NSString stringWithFormat:@"%f",uId] componentsSeparatedByString:@"."];
    NSInteger role = [defaults doubleForKey:@"userDataRole"];
    
    [defaults setBool:NO forKey:@"userLoginState"];
    if (role == 0) {
        [UMessage removeAlias:arr[0] type:@"HKX_MACHINE" response:^(id  _Nonnull responseObject, NSError * _Nonnull error) {
            
        }];
       
    }else if(role == 1){
        
        
        [UMessage removeAlias:arr[0] type:@"HKX_REPAIR" response:^(id  _Nonnull responseObject, NSError * _Nonnull error) {
            
        }];
    }else if(role == 2){
        
        [UMessage removeAlias:arr[0] type:@"HKX_SUPPLIER" response:^(id  _Nonnull responseObject, NSError * _Nonnull error) {
            
        }];    }
    
    UIWindow * window = [[[UIApplication sharedApplication] delegate] window];
    ViewController * loginVC = [[ViewController alloc] init];
    window.rootViewController = loginVC;
    [window makeKeyWindow];
}
#pragma mark - Private Method
/**
 @ 调用ActionSheet
 */
- (void)callActionSheetFunc{
    if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
    {
        
        self.actionSheet = [[UIActionSheet alloc] initWithTitle:@"选择图像" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"拍照", @"从相册选择",nil];
        
    }
    else
    {
        self.actionSheet = [[UIActionSheet alloc] initWithTitle:@"选择图像" delegate:self cancelButtonTitle:@"取消"destructiveButtonTitle:nil otherButtonTitles:@"从相册选择", nil];
    }
    
    self.actionSheet.tag = 1000;
    [self.actionSheet showInView:self.view];
}
//通过图片Data数据第一个字节 来获取图片扩展名
- (NSString *)contentTypeForImageData:(NSData *)data {
    uint8_t c;
    [data getBytes:&c length:1];
    switch (c) {
        case 0xFF:
            return @"jpeg";
        case 0x89:
            return @"png";
        case 0x47:
            return @"gif";
        case 0x49:
        case 0x4D:
            return @"tiff";
        case 0x52:
            if ([data length] < 12) {
                return nil;
            }
            NSString *testString = [[NSString alloc] initWithData:[data subdataWithRange:NSMakeRange(0, 12)] encoding:NSASCIIStringEncoding];
            if ([testString hasPrefix:@"RIFF"] && [testString hasSuffix:@"WEBP"]) {
                return @"webp";
            }
            return nil;
    }
    return nil;
}
// Called when a button is clicked. The view will be automatically dismissed after this call returns
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (actionSheet.tag == 1000) {
        NSUInteger sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        // 判断是否支持相机
        if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
            switch (buttonIndex) {
                case 0:
                    //来源:相机
                    sourceType = UIImagePickerControllerSourceTypeCamera;
                    break;
                case 1:
                    //来源:相册
                    sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
                    break;
                case 2:
                    return;
            }
        }
        else {
            if (buttonIndex == 2) {
                return;
            } else {
                sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
            }
        }
        // 跳转到相机或相册页面
        UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
        imagePickerController.delegate = self;
        imagePickerController.allowsEditing = YES;
        imagePickerController.sourceType = sourceType;
        
        [self presentViewController:imagePickerController animated:YES completion:^{
            
        }];
    }
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    [picker dismissViewControllerAnimated:YES completion:^{
        UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
        UIView * backView = [self.view viewWithTag:890];
        UIButton * headImageBtn = [backView viewWithTag:859];
        [headImageBtn setImage:image forState:UIControlStateNormal];
        
        NSData * data = UIImageJPEGRepresentation(image, 0.3);
        NSString * dataStr = [data base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
        
        NSString * typeStr = [self contentTypeForImageData:data];
        _headBase64String = [NSString stringWithFormat:@"data:image/%@;base64,%@",typeStr,dataStr];
        
        [HKXHttpRequestManager sendRequestWithUserId:[NSString stringWithFormat:@"%ld",_userId] WithPhotoString:_headBase64String ToGetUpdateImageResult:^(id data) {
            HKXUserVertificationCodeResultModel * model = data;
            CustomSubmitView * customAlertView = [CustomSubmitView alertViewWithTitle:@"提示" content:model.message sure:@"确定" sureBtnClick:^{
                [self tapGestureClick];
            } WithAlertHeight:160];
            customAlertView.tag = 501;
            [self.view addSubview:customAlertView];
        }];
    }];
    
}
/**
 *  沙盒路径
 *
 *  @return 沙盒路径
 */
- (NSString *)getFilePath
{
    NSFileManager * manager = [NSFileManager defaultManager];
    NSString * filePath = [NSHomeDirectory() stringByAppendingPathComponent:@"/Documents/OAUser.plist"];
    if (![manager fileExistsAtPath:filePath])
    {
        [[NSFileManager defaultManager] createFileAtPath:filePath contents:nil attributes:nil];
    }
    return filePath;
}

#pragma mark - Delegate & Data Source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (_roleID == 0)
    {
        return 12;
    }
    else if (_roleID == 1)
    {
        return 16;
    }
    else
    {
        return 18;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    int logOutCellIndex ;
    if (_roleID == 0)
    {
        logOutCellIndex = 12;
    }
    else if (_roleID == 1)
    {
        logOutCellIndex = 16;
    }
    else
    {
        logOutCellIndex = 18;
    }
    AppDelegate * myDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    if (indexPath.row == 0)
    {
        return 49 * myDelegate.autoSizeScaleY;
    }
    else if (indexPath.row == logOutCellIndex - 1)
    {
        return (tableView.frame.size.height - 40 * myDelegate.autoSizeScaleY * 6 - 49 * myDelegate.autoSizeScaleY);
    }
    else
    {
        return 40 * myDelegate.autoSizeScaleY;
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    AppDelegate * myDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    static NSString * cellIdentifier = @"cell";
    int logOutCellIndex ;
    if (_roleID == 0)
    {
        logOutCellIndex = 12;
    }
    else if (_roleID == 1)
    {
        logOutCellIndex = 16;
    }
    else
    {
        logOutCellIndex = 18;
    }
    
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellIdentifier];
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if (_roleID != 2)
    {
        if (indexPath.row >= 5 && indexPath.row != logOutCellIndex - 1)
        {
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }
        else
        {
            cell.accessoryType = UITableViewCellAccessoryNone;
        }
    }
    else
    {
        if (indexPath.row >= 6 && indexPath.row != logOutCellIndex - 1)
        {
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }
        else
        {
            cell.accessoryType = UITableViewCellAccessoryNone;
        }
    }
    NSArray * leftJiZhuTextArray = @[@"姓名",@"电话",@"地区",@"单位",@"推荐码",@"设备报修",@"我的设备",@"收货地址",@"购物车",@"买入订单",@"我的租赁"];
    NSArray * leftFuWuTextArray = @[@"姓名",@"电话",@"地区",@"单位",@"推荐码",@"我的钱包",@"证书资料",@"维修订单",@"发布配件",@"配件管理",@"收货地址",@"购物车",@"买入订单",@"卖出订单",@"求租"];
    NSArray * leftGongYingShangTextArray = @[@"姓名",@"电话",@"地区",@"单位",@"订单信息",@"推荐码",@"我的钱包",@"发布配件",@"配件管理",@"发布设备",@"设备管理",@"收货地址",@"购物车",@"买入订单",@"卖出订单",@"求租",@"设备询价"];
    NSMutableArray * leftDetailTextArray = [NSMutableArray arrayWithObjects:@"userName",@"userPhone",@"userAddress",@"userCompany",@"推荐码", nil];
    NSMutableArray * leftGongYingShangDetailTextArray = [NSMutableArray arrayWithObjects:@"userName", @"userPhone",@"userAddress",@"userCompany",@"您有1条新的订单消息",@"推荐码",nil];
    
    if (_roleID == 0)
    {
        if (self.ownerInfoModel.data != nil && (self.ownerInfoModel.data.realName != nil ))
        {
            [leftDetailTextArray replaceObjectAtIndex:0 withObject:self.ownerInfoModel.data.realName];
        }
        
        if (self.ownerInfoModel.data != nil &&(![self.ownerInfoModel.data.username isEqualToString:@""]))
        {
            [leftDetailTextArray replaceObjectAtIndex:1 withObject:self.ownerInfoModel.data.username];
        }
        if (self.ownerInfoModel.data != nil &&(![self.ownerInfoModel.data.address isEqualToString:@"nullnullnullnull"]))
        {
            [leftDetailTextArray replaceObjectAtIndex:2 withObject:self.ownerInfoModel.data.address];
        }
        if (self.ownerInfoModel.data != nil &&(self.ownerInfoModel.data.companyName != nil))
        {
            [leftDetailTextArray replaceObjectAtIndex:3 withObject:self.ownerInfoModel.data.companyName];
        }
        if (self.ownerInfoModel.data != nil &&(self.ownerInfoModel.data.recommendCode != nil))
        {
            [leftDetailTextArray replaceObjectAtIndex:4 withObject:self.ownerInfoModel.data.recommendCode];
        }
        
        
    }
    if (_roleID == 1)
    {
        if (self.serveInfoModel.data != nil && self.serveInfoModel.data.realName != nil )
        {
            [leftDetailTextArray replaceObjectAtIndex:0 withObject:self.serveInfoModel.data.realName];
        }
        
        if (self.serveInfoModel.data != nil &&![self.serveInfoModel.data.username isEqualToString:@""])
        {
            [leftDetailTextArray replaceObjectAtIndex:1 withObject:self.serveInfoModel.data.username];
        }
        if (self.serveInfoModel.data != nil &&![self.serveInfoModel.data.address isEqualToString:@"nullnullnullnull"])
        {
            [leftDetailTextArray replaceObjectAtIndex:2 withObject:self.serveInfoModel.data.address];
        }
        if (self.serveInfoModel.data != nil && self.serveInfoModel.data.companyName != nil)
        {
            [leftDetailTextArray replaceObjectAtIndex:3 withObject:self.serveInfoModel.data.companyName];
        }
        if (self.serveInfoModel.data != nil && self.serveInfoModel.data.recommendCode != nil)
        {
            [leftDetailTextArray replaceObjectAtIndex:4 withObject:self.serveInfoModel.data.recommendCode];
        }
        
        
    }
    if (_roleID == 2)
    {
        if (self.supplierInfoModel.data != nil &&![self.supplierInfoModel.data.realName isEqualToString:@"null"] )
        {
            [leftGongYingShangDetailTextArray replaceObjectAtIndex:0 withObject:self.supplierInfoModel.data.realName];
        }
        if (self.supplierInfoModel.data != nil &&![self.supplierInfoModel.data.username isEqualToString:@""])
        {
            [leftGongYingShangDetailTextArray replaceObjectAtIndex:1 withObject:self.supplierInfoModel.data.username];
        }
        if (self.supplierInfoModel.data != nil &&![self.supplierInfoModel.data.address isEqualToString:@"nullnullnullnull"])
        {
            [leftGongYingShangDetailTextArray replaceObjectAtIndex:2 withObject:self.supplierInfoModel.data.address];
        }
        if (self.supplierInfoModel.data != nil && self.supplierInfoModel.data.companyName != nil)
        {
            [leftGongYingShangDetailTextArray replaceObjectAtIndex:3 withObject:self.supplierInfoModel.data.companyName];
        }

        if (self.supplierInfoModel.data != nil && self.supplierInfoModel.data.recommendCode != nil)
        {
            
            [leftGongYingShangDetailTextArray replaceObjectAtIndex:5 withObject:self.supplierInfoModel.data.recommendCode];
            
        }
    }

    
    UILabel * reLeftTextLabel = [cell viewWithTag:20001];
    [reLeftTextLabel removeFromSuperview];
    
    for (UIView *tf in cell.subviews) {
        
        if ([tf isKindOfClass:[UITextField class]]) {
            
            [tf removeFromSuperview];
        }
    }
    UIButton * reLogOutBtn = [cell viewWithTag:20002];
    [reLogOutBtn removeFromSuperview];
    
    NSArray * leftTextArray = [NSArray array];
    if (_roleID == 0)
    {
        leftTextArray = leftJiZhuTextArray;
    }
    else if (_roleID == 1)
    {
        leftTextArray = leftFuWuTextArray;
    }
    else
    {
        leftTextArray = leftGongYingShangTextArray;
    }
    
    if (indexPath.row != logOutCellIndex - 1)
    {
        float Yposition;
        Yposition = indexPath.row == 0 ? 9 * myDelegate.autoSizeScaleY : 0 ;
        UILabel * leftTextLabel = [[UILabel alloc] initWithFrame:CGRectMake(22 * myDelegate.autoSizeScaleX, Yposition, [CommonMethod getLabelLengthWithString:leftTextArray[indexPath.row] WithFont:14 * myDelegate.autoSizeScaleX], 40 * myDelegate.autoSizeScaleY)];
        leftTextLabel.tag = 20001;
        leftTextLabel.textAlignment = NSTextAlignmentLeft;
        leftTextLabel.textColor = [CommonMethod getUsualColorWithString:@"#333333"];
        leftTextLabel.font = [UIFont systemFontOfSize:14 * myDelegate.autoSizeScaleX];
        leftTextLabel.text = leftTextArray[indexPath.row];
//        leftTextLabel.backgroundColor = [UIColor redColor];
        [cell addSubview:leftTextLabel];
        
        UITextField * detailLeftTextLabel = [[UITextField alloc] initWithFrame:CGRectMake(CGRectGetMaxX(leftTextLabel.frame) + 13 * myDelegate.autoSizeScaleX, Yposition,ScreenWidth - (leftTextLabel.frame.size.width) - 45 * myDelegate.autoSizeScaleX, 40 * myDelegate.autoSizeScaleY)];
        
        detailLeftTextLabel.tag = indexPath.row + 100;
//        detailLeftTextLabel.backgroundColor = [UIColor greenColor];
        detailLeftTextLabel.textAlignment = NSTextAlignmentLeft;
        detailLeftTextLabel.textColor = [CommonMethod getUsualColorWithString:@"#666666"];
        detailLeftTextLabel.font = [UIFont systemFontOfSize:14 * myDelegate.autoSizeScaleX];
        if (rightBtn.selected) {
            
            detailLeftTextLabel.userInteractionEnabled = YES;
            
        }else{
            
            detailLeftTextLabel.userInteractionEnabled = NO;
        }
        if(indexPath.row < 6){
            
            [cell addSubview:detailLeftTextLabel];
        }
        
        
        if (_roleID != 2)
        {
            if (indexPath.row < 5)
            {
                
                detailLeftTextLabel.text = leftDetailTextArray[indexPath.row];
            }
        }
        else
        {
            if (indexPath.row < 6)
            {
                
                detailLeftTextLabel.text = leftGongYingShangDetailTextArray[indexPath.row];
              
            }
        }
        
    }
    else
    {
        UIButton * logOutBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        logOutBtn.tag = 20002;
        logOutBtn.frame = CGRectMake(49 * myDelegate.autoSizeScaleX, 41 * myDelegate.autoSizeScaleY, 554 / 2 * myDelegate.autoSizeScaleX, 44 * myDelegate.autoSizeScaleY);
        logOutBtn.backgroundColor = [UIColor redColor];
        [logOutBtn setTitle:@"退出登录" forState:UIControlStateNormal];
        [logOutBtn addTarget:self action:@selector(logoutBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        logOutBtn.layer.cornerRadius = 2 * myDelegate.autoSizeScaleX;
        logOutBtn.clipsToBounds = YES;
        [cell addSubview:logOutBtn];
    }
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    self.hidesBottomBarWhenPushed = YES;
//    服务维修
    if (_roleID == 1)
    {
//        证书资料
        if (indexPath.row == 6)
        {
            HKXMineServeCertificateProfileViewController * certificateProfileVC = [[HKXMineServeCertificateProfileViewController alloc] init];
            certificateProfileVC.navigationItem.title = @"证书资料";
            [self.navigationController pushViewController:certificateProfileVC animated:YES];
        }
//        维修订单
        if (indexPath.row == 7)
        {
            
            HKXMineServerOrderListViewController * orderListVC = [[HKXMineServerOrderListViewController alloc] init];
            orderListVC.navigationItem.title = @"维修订单";
            [self.navigationController pushViewController:orderListVC animated:YES];
        }
//        我的钱包
        if (indexPath.row == 5)
        {
            HKXMineMyWalletViewController * myWalletVC = [[HKXMineMyWalletViewController alloc] init];
            myWalletVC.navigationItem.title = @"我的钱包";
            myWalletVC.isCard = false;
            [self.navigationController pushViewController:myWalletVC animated:YES];
        }
//        发布配件
        if (indexPath.row == 8)
        {
            HKXSupplierReleasePartsViewController * releasePartsVC = [[HKXSupplierReleasePartsViewController alloc] init];
            releasePartsVC.navigationItem.title = @"发布配件";
            releasePartsVC.isEditable = YES;
            [self.navigationController pushViewController:releasePartsVC animated:YES];
        }
//        配件管理
        if (indexPath.row == 9)
        {
            HKXSupplierPartsAndEquipmentManagmentViewController * partsAndEquipmentManagementVC = [[HKXSupplierPartsAndEquipmentManagmentViewController alloc] init];
            partsAndEquipmentManagementVC.navigationItem.title = @"配件管理";
            partsAndEquipmentManagementVC.isParts = true;
            [self.navigationController pushViewController:partsAndEquipmentManagementVC animated:YES];
        }
//        收货地址
        if (indexPath.row == 10)
        {
            HKXMineReceiveAddressViewController * addListVC = [[HKXMineReceiveAddressViewController alloc] init];
            addListVC.navigationItem.title = @"收货地址";
            [self.navigationController pushViewController:addListVC animated:YES];
        }
//        购物车
        if (indexPath.row == 11)
        {
            HKXMineShoppingCartViewController * shoppingCartVC = [[HKXMineShoppingCartViewController alloc] init];
            shoppingCartVC.navigationItem.title = @"购物车";
            [self.navigationController pushViewController:shoppingCartVC animated:YES];
        }
//        买入订单
        if (indexPath.row == 12)
        {
            HKXMineBuyingListViewController * buyingListVC = [[HKXMineBuyingListViewController alloc] init];
            buyingListVC.navigationItem.title = @"买入订单";
            [self.navigationController pushViewController:buyingListVC animated:YES];
        }
//        卖出订单
        if (indexPath.row == 13)
        {
            HKXMineSaleListViewController * saleListVC = [[HKXMineSaleListViewController alloc] init];
            saleListVC.navigationItem.title = @"卖出订单";
            [self.navigationController pushViewController:saleListVC animated:YES];
        }
//        求租
        if (indexPath.row == 14)
        {
            SeverMyByLeaseViewController * SeverMyByLeaseVC = [[SeverMyByLeaseViewController alloc] init];
            
            [self.navigationController pushViewController:SeverMyByLeaseVC animated:YES];
        }
    }
//    供应商
    if (_roleID == 2)
    {
//        我的钱包
        if (indexPath.row == 6)
        {
            HKXMineMyWalletViewController * myWalletVC = [[HKXMineMyWalletViewController alloc] init];
            myWalletVC.navigationItem.title = @"我的钱包";
            myWalletVC.isCard = false;
            [self.navigationController pushViewController:myWalletVC animated:YES];
        }
//        发布配件
        if (indexPath.row == 7)
        {
            HKXSupplierReleasePartsViewController * releasePartsVC = [[HKXSupplierReleasePartsViewController alloc] init];
            releasePartsVC.navigationItem.title = @"发布配件";
            releasePartsVC.isEditable = YES;
            [self.navigationController pushViewController:releasePartsVC animated:YES];
        }
//        发布设备
        if (indexPath.row == 9)
        {
            HKXSupplierReleaseEquipmentViewController * releaseEquipmentVC = [[HKXSupplierReleaseEquipmentViewController alloc] init];
            releaseEquipmentVC.navigationItem.title = @"发布设备";
            releaseEquipmentVC.isEditable = YES;
            [self.navigationController pushViewController:releaseEquipmentVC animated:YES];
        }
//        配件管理/设备管理
        if (indexPath.row == 8 || indexPath.row == 10)
        {
            HKXSupplierPartsAndEquipmentManagmentViewController * partsAndEquipmentManagementVC = [[HKXSupplierPartsAndEquipmentManagmentViewController alloc] init];
            [self.navigationController pushViewController:partsAndEquipmentManagementVC animated:YES];
            if (indexPath.row == 8)
            {
                partsAndEquipmentManagementVC.navigationItem.title = @"配件管理";
                partsAndEquipmentManagementVC.isParts = true;
                
            }
            else
            {
                partsAndEquipmentManagementVC.navigationItem.title = @"设备管理";
                partsAndEquipmentManagementVC.isParts = false;
            }
        }
        //        求租
        if (indexPath.row == 15)
        {
            SupplierMyByLeaseViewController * SupplierMyByLeaseVC = [[SupplierMyByLeaseViewController alloc] init];
            
            [self.navigationController pushViewController:SupplierMyByLeaseVC animated:YES];
        }
//        设备询价
        if (indexPath.row == 16)
        {
            HKXMineSupplierAskValueListViewController * askValueListVC = [[HKXMineSupplierAskValueListViewController alloc] init];
            askValueListVC.navigationItem.title = @"询价列表";
            [self.navigationController pushViewController:askValueListVC animated:YES];
        }
        //        买入订单
        if (indexPath.row == 13)
        {
            HKXMineBuyingListViewController * buyingListVC = [[HKXMineBuyingListViewController alloc] init];
            buyingListVC.navigationItem.title = @"买入订单";
            [self.navigationController pushViewController:buyingListVC animated:YES];
        }
        //        卖出订单
        if (indexPath.row == 14)
        {
            HKXMineSaleListViewController * saleListVC = [[HKXMineSaleListViewController alloc] init];
            saleListVC.navigationItem.title = @"卖出订单";
            [self.navigationController pushViewController:saleListVC animated:YES];
        }
//        收货地址
        if (indexPath.row == 11)
        {
            HKXMineReceiveAddressViewController * addListVC = [[HKXMineReceiveAddressViewController alloc] init];
            addListVC.navigationItem.title = @"收货地址";
            [self.navigationController pushViewController:addListVC animated:YES];
        }
//        购物车
        if (indexPath.row == 12)
        {
            HKXMineShoppingCartViewController * shoppingCartVC = [[HKXMineShoppingCartViewController alloc] init];
            shoppingCartVC.navigationItem.title = @"购物车";
            [self.navigationController pushViewController:shoppingCartVC animated:YES];
        }
    }
    if (_roleID == 0)
    {
//        设备报修
        if (indexPath.row == 5)
        {
            HKXMineOwnerRepairListViewController * ownerRepairListVC = [[HKXMineOwnerRepairListViewController alloc] init];
            ownerRepairListVC.navigationItem.title = @"设备报修";
            [self.navigationController pushViewController:ownerRepairListVC animated:YES];
        }
//        设备列表
        if (indexPath.row == 6)
        {
            HKXMineOwnerEquipmentListViewController * equipmentListVC = [[HKXMineOwnerEquipmentListViewController alloc] init];
            equipmentListVC.navigationItem.title = @"设备列表";
            [self.navigationController pushViewController:equipmentListVC animated:YES];
        }
//        收货地址
        if (indexPath.row == 7)
        {
            HKXMineReceiveAddressViewController * addListVC = [[HKXMineReceiveAddressViewController alloc] init];
            addListVC.navigationItem.title = @"收货地址";
            [self.navigationController pushViewController:addListVC animated:YES];
        }
//        购物车
        if (indexPath.row == 8)
        {
            HKXMineShoppingCartViewController * shoppingCartVC = [[HKXMineShoppingCartViewController alloc] init];
            shoppingCartVC.navigationItem.title = @"购物车";
            [self.navigationController pushViewController:shoppingCartVC animated:YES];
        }
//        买入订单
        if (indexPath.row == 9)
        {
            HKXMineBuyingListViewController * buyingListVC = [[HKXMineBuyingListViewController alloc] init];
            buyingListVC.navigationItem.title = @"买入订单";
            [self.navigationController pushViewController:buyingListVC animated:YES];
        }
//        我的租赁
        if (indexPath.row == 10)
        {
            OwerMyleaseViewController * OwerMyleaseVC = [[OwerMyleaseViewController alloc] init];
            
            [self.navigationController pushViewController:OwerMyleaseVC animated:YES];
        }
        
    }
    self.hidesBottomBarWhenPushed = NO;
}
#pragma mark - Setters & Getters


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
