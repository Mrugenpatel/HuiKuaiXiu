//
//  HKXOwnerMoreInfoViewController.m
//  HuiKuaiXiuPro
//
//  Created by 李金灿 on 2017/7/3.
//  Copyright © 2017年 Lee. All rights reserved.
//

#import "HKXOwnerMoreInfoViewController.h"
#import "CommonMethod.h"
#import "CustomDropDownBtn.h"
#import "CustomAlertView.h"
#import "CustomSubmitView.h"
#import "HKXNavigationController.h"
#import "HKXOwnerRegisterMachineModel.h"//机主设备录入信息model
#import "HKXUserVertificationCodeResultModelDataModels.h"//设备录入返回结果

#import "HKXHttpRequestManager.h"

#import "HKXHomePageViewController.h"//homePage
#import "HKXShoppingMallViewController.h"//shoppingMall
#import "HKXRepairsViewController.h"//repairs
#import "HKXOrderReceivingViewController.h"//orderReceiving
#import "HKXLeaseViewController.h"//lease
#import "HKXMineViewController.h"//mine
#import "HKXRepairsViewController.h"

#import "HKXMineConfirmOrderResultModelDataModels.h"

#import <Photos/Photos.h>
#import <CTAssetsPickerController/CTAssetsPickerController.h>
#import <AssetsLibrary/ALAsset.h>
#import <AssetsLibrary/ALAssetsLibrary.h>
#import <AssetsLibrary/ALAssetsGroup.h>
#import <AssetsLibrary/ALAssetRepresentation.h>

#import <UShareUI/UShareUI.h>

@interface HKXOwnerMoreInfoViewController ()<CustomDropDownDelegate ,CTAssetsPickerControllerDelegate ,UIImagePickerControllerDelegate>
{
    UIScrollView * _bottomScrollView;
    
    NSString     * _baseString;//图片转化的base64数据
}
@property (nonatomic , strong) HKXOwnerRegisterMachineModel * machineModel;
@property (nonatomic ,weak) CustomDropDownBtn * dropDownBtn;

@property (nonatomic , strong) NSMutableArray * imageArray;//选择的图片数组

@end

@implementation HKXOwnerMoreInfoViewController

#pragma mark - LifeCycle
- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self createUI];
}
#pragma mark - CreateUI
- (void)createUI
{
    _baseString = [[NSString alloc] init];

    self.automaticallyAdjustsScrollViewInsets = NO;
    AppDelegate * myDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    self.view.backgroundColor = [UIColor colorWithRed:233 / 255.0 green:233 / 255.0 blue:233 / 255.0 alpha:1];
    
    self.navigationItem.title = @"机主";

    _bottomScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 20 + 40 + 10 * myDelegate.autoSizeScaleY, ScreenWidth, ScreenHeight - 20 - 60 - 10 * myDelegate.autoSizeScaleY)];
    _bottomScrollView.backgroundColor = [UIColor whiteColor];
    _bottomScrollView.contentSize = CGSizeMake(ScreenWidth, ScreenHeight - 20 - 60 - 10 * myDelegate.autoSizeScaleY);
    _bottomScrollView.pagingEnabled = NO;
    _bottomScrollView.bounces = NO;
    [self.view addSubview:_bottomScrollView];
    
    NSArray * placeHolderArray = @[@"整机名牌号",@"设备类型",@"品牌",@"型号",@"出厂日期",@"设备所在地",@"关键参数",@"备注",];
    for (int i = 0; i < placeHolderArray.count; i ++)
    {
        UITextField * pswTF = [[UITextField alloc] initWithFrame:CGRectMake(22 * myDelegate.autoSizeScaleX, 10 * myDelegate.autoSizeScaleY + (10 + 40) * i * myDelegate.autoSizeScaleY, ScreenWidth - 44 * myDelegate.autoSizeScaleX, 40 * myDelegate.autoSizeScaleY)];
        
        pswTF.placeholder = placeHolderArray[i];
        pswTF.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10 * myDelegate.autoSizeScaleX, pswTF.frame.size.height)];
        pswTF.leftView.backgroundColor = [UIColor clearColor];
        pswTF.leftViewMode = UITextFieldViewModeAlways;
        pswTF.borderStyle = UITextBorderStyleRoundedRect;
        pswTF.tag = 4000 + i;
        pswTF.layer.borderColor = [[CommonMethod getUsualColorWithString:@"#a0a0a0"] CGColor];
        [_bottomScrollView addSubview:pswTF];
        
        if (i == 1)
        {
            CustomDropDownBtn * optionBtn = [[CustomDropDownBtn alloc] initWithFrame:CGRectMake(250 * myDelegate.autoSizeScaleX, 0, 80 * myDelegate.autoSizeScaleX, pswTF.frame.size.height)];
            optionBtn.array = [NSMutableArray arrayWithObjects:@"挖掘机",@"推土机",@"铲车", nil];
            optionBtn.delegate = self;
            [pswTF addSubview:optionBtn];
            self.dropDownBtn = optionBtn;
        }
    }
    
    UITextField * remarkLabel = [_bottomScrollView viewWithTag:4007];
    UILabel * picLabel = [[UILabel alloc] initWithFrame:CGRectMake(22 * myDelegate.autoSizeScaleX, CGRectGetMaxY(remarkLabel.frame) + 23 * myDelegate.autoSizeScaleY,  [CommonMethod getLabelLengthWithString:@"设备照片" WithFont:17 * myDelegate.autoSizeScaleX], 17 * myDelegate.autoSizeScaleY)];
    picLabel.text = @"设备照片";
    picLabel.font = [UIFont systemFontOfSize:17 * myDelegate.autoSizeScaleX];
    [_bottomScrollView addSubview:picLabel];
    
    UIButton * addPicBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    addPicBtn.frame = CGRectMake(CGRectGetMaxX(picLabel.frame) + 17 * myDelegate.autoSizeScaleX , CGRectGetMaxY(remarkLabel.frame) + 23 * myDelegate.autoSizeScaleY, 194 / 2 * myDelegate.autoSizeScaleX , 122 / 2 * myDelegate.autoSizeScaleY);
    CAShapeLayer *border = [CAShapeLayer layer];
    border.strokeColor = [CommonMethod getUsualColorWithString:@"#a0a0a0"].CGColor;
    border.fillColor = nil;
    border.path = [UIBezierPath bezierPathWithRect:addPicBtn.bounds].CGPath;
    border.frame = addPicBtn.bounds;
    border.lineWidth = 0.5;
    border.lineCap = @"square";
    border.lineDashPattern = @[@4, @2];
    [addPicBtn.layer addSublayer:border];
    addPicBtn.tag = 700;
    [addPicBtn addTarget:self action:@selector(openPhotoLibraryBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [_bottomScrollView addSubview:addPicBtn];
    
    UIImageView * addImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"添加"]];
    
    addImage.frame = CGRectMake(75 / 2 * myDelegate.autoSizeScaleX , 39 / 2 * myDelegate.autoSizeScaleY, 22 * myDelegate.autoSizeScaleX, 22 * myDelegate.autoSizeScaleX);
    [addPicBtn addSubview:addImage];
    
    UIButton * submitBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    submitBtn.frame = CGRectMake((ScreenWidth - 274 * myDelegate.autoSizeScaleX) / 2, CGRectGetMaxY(addPicBtn.frame) + 38 * myDelegate.autoSizeScaleY, 274 * myDelegate.autoSizeScaleX, 44 * myDelegate.autoSizeScaleY);
    submitBtn.layer.cornerRadius = 3 * myDelegate.autoSizeScaleY;
    submitBtn.clipsToBounds = YES;
    [submitBtn setTitle:@"提 交" forState:UIControlStateNormal];
    submitBtn.tag = 750;
    submitBtn.backgroundColor = [CommonMethod getUsualColorWithString:@"#ffa304"];
    [submitBtn addTarget:self action:@selector(submitBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [_bottomScrollView addSubview:submitBtn];
    
    float length = [CommonMethod getLabelLengthWithString:@"设备照片" WithFont:17 * myDelegate.autoSizeScaleY];
    for (int i = 0; i < 4; i ++)
    {
        int x = i % 2;
        int y = i / 2;
        UIImageView * selectedImageView = [[UIImageView alloc] initWithFrame:CGRectMake((length + (22 + 17) * myDelegate.autoSizeScaleX ) + x * 100 * myDelegate.autoSizeScaleX, 423 * myDelegate.autoSizeScaleY + y * 70 * myDelegate.autoSizeScaleY, 97 * myDelegate.autoSizeScaleX, 61 * myDelegate.autoSizeScaleY)];
        [_bottomScrollView addSubview:selectedImageView];
        selectedImageView.hidden = YES;
        [self.imageArray addObject:selectedImageView];
    }
    
}
#pragma mark - ConfigData
- (void)prepareData
{
    if ([self.mark isEqualToString:@"报修"]) {
        
        NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
        double uId = [defaults doubleForKey:@"userDataId"];
        NSInteger i = uId;
        self.machineModel.uId = [NSString stringWithFormat:@"%ld",i];
        
    }else{
        self.machineModel.uId = [NSString stringWithFormat:@"%ld",self.userRegisterData.dataIdentifier];
    }
    
    
    UITextField * nameTF = [_bottomScrollView viewWithTag:4000];
    self.machineModel.nameplateNum = [nameTF.text isEqualToString:@""] ? (NSString *)[NSNull null] : nameTF.text;
    UITextField * brandTF = [_bottomScrollView viewWithTag:4002];
    self.machineModel.brand = [brandTF.text isEqualToString:@""] ? (NSString *)[NSNull null] : brandTF.text;
    UITextField * modelTF = [_bottomScrollView viewWithTag:4003];
    self.machineModel.model = [modelTF.text isEqualToString:@""] ? (NSString *)[NSNull null] : modelTF.text;
    UITextField * buyDateTF = [_bottomScrollView viewWithTag:4004];
    self.machineModel.buyDate = [buyDateTF.text isEqualToString:@""] ? (NSString *)[NSNull null] : buyDateTF.text;
    UITextField * locationTF = [_bottomScrollView viewWithTag:4005];
    self.machineModel.address = [locationTF.text isEqualToString:@""] ? (NSString *)[NSNull null] : locationTF.text;
    UITextField * paraTF = [_bottomScrollView viewWithTag:4006];
    self.machineModel.parameter = [paraTF.text isEqualToString:@""] ? (NSString *)[NSNull null] : paraTF.text;
    UITextField * remarksTF = [_bottomScrollView viewWithTag:4007];
    self.machineModel.remarks = [remarksTF.text isEqualToString:@""] ? (NSString *)[NSNull null] : remarksTF.text;
    
    self.machineModel.picture = _baseString;
    
    
    if ([self.machineModel.category isEqualToString:@""])
    {
        UIView * backGroundView = [[UIView alloc] initWithFrame:self.view.bounds];
        backGroundView.backgroundColor = [UIColor darkGrayColor];
        backGroundView.alpha = 0.3;
        backGroundView.tag = 500;
        [self.view addSubview:backGroundView];
        UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGestureClick)];
        [backGroundView addGestureRecognizer:tap];
        CustomSubmitView * customAlertView = [CustomSubmitView alertViewWithTitle:@"提示" content:@"输入内容不可为空" sure:@"确定" sureBtnClick:^{
            [self tapGestureClick];
        } WithAlertHeight:160];
        customAlertView.tag = 501;
        [self.view addSubview:customAlertView];
        return;
    }
}
#pragma mark - Action
- (void)submitBtnClick
{
    [self prepareData];
    [self.view showActivity];
    [HKXHttpRequestManager sendRequestWithOwnerInfo:self.machineModel ToGetOwnerAddMachineResult:^(id data) {
        [self.view hideActivity];
        HKXMineConfirmOrderResultModel * model = data;
        if (model.success)
        {
            AppDelegate * myDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
            UIView * backGroundView = [[UIView alloc] initWithFrame:self.view.bounds];
            backGroundView.backgroundColor = [UIColor darkGrayColor];
            backGroundView.alpha = 0.3;
            backGroundView.tag = 500;
            [self.view addSubview:backGroundView];
            UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGestureClick)];
            [backGroundView addGestureRecognizer:tap];
            
            CustomAlertView * submitAlertView = [CustomAlertView alertViewWithTitle:@"资料上传完成" content:@"是否再次添加新的设备" cancel:@"完成" sure:@"再次添加" cancelBtnClick:^{
                
                if (_userRegisterData.recommendCode.length == 0) {
                    
                    for (UIView * view in self.view.subviews)
                    {
                        if (view.tag == 500 || view.tag == 501 || view.tag == 502)
                        {
                            [view removeFromSuperview];
                        }
                    }
                    UITextField * tf1 = [_bottomScrollView viewWithTag:4002];
                    UITextField * tf2 = [_bottomScrollView viewWithTag:4003];
                    self.returnBrandBlock([NSString stringWithFormat:@"%@%@",tf1.text,tf2.text], [NSString stringWithFormat:@"%ld",(long)model.data]);
                    [self.navigationController popViewControllerAnimated:YES];
                    
                }else{
                
                [self showRecommandCode];
                    
                }
            } sureBtnClick:^{
                [self resetMachineInfo];
            } WithAlertHeight:180 * myDelegate.autoSizeScaleY];
            submitAlertView.tag = 501;
            [self.view addSubview:submitAlertView];
        }else{
            
            [self showHint:model.message];
        }
    }];
    
}
- (void)tapGestureClick
{
    for (UIView * view in self.view.subviews)
    {
        if (view.tag == 500 || view.tag == 501 || view.tag == 502)
        {
            [view removeFromSuperview];
        }
    }
    UIWindow * window = [[[UIApplication sharedApplication] delegate] window];
    for (UIView * view in window.subviews)
    {
        if (view.tag == 500000 || view.tag == 500001 || view.tag == 500002)
        {
            [view removeFromSuperview];
        }
    }
}
- (void)openPhotoLibraryBtnClick
{
//    for (UIImageView * imag in self.imageArray)
//    {
//        imag.image = NULL;
//    }
    [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
        if (status != PHAuthorizationStatusAuthorized) return;
        dispatch_async(dispatch_get_main_queue(), ^{
            CTAssetsPickerController * pickerVC = [[CTAssetsPickerController alloc] init];
            pickerVC.delegate = self;
            pickerVC.showsSelectionIndex = YES;
            pickerVC.showsEmptyAlbums = NO;
            [self presentViewController:pickerVC animated:YES completion:nil];
        });
    }];
}
/**
 根据不同角色，布局相应首页tabbar
 */
- (void)createTabbar:(int)userId
{
    NSMutableArray * tabbarArray = [NSMutableArray array];
    NSMutableArray * sonClassVCArray = [NSMutableArray array];
    if (userId == 0)
    {
        //        机主角色
        tabbarArray = [NSMutableArray arrayWithObjects:@"首页",@"商城",@"报修",@"租赁",@"我的", nil];
        sonClassVCArray = [NSMutableArray arrayWithObjects:@"HKXHomePageViewController",@"HKXShoppingMallViewController",@"HKXRepairsViewController",@"HKXLeaseViewController",@"HKXMineViewController", nil];
    }
    if (userId == 2)
    {
        //        供应商角色
        tabbarArray = [NSMutableArray arrayWithObjects:@"首页",@"商城",@"租赁",@"我的", nil];
        sonClassVCArray = [NSMutableArray arrayWithObjects:@"HKXHomePageViewController",@"HKXShoppingMallViewController",@"HKXLeaseViewController",@"HKXMineViewController", nil];
    }
    if (userId == 1)
    {
        //        服务维修角色
        tabbarArray = [NSMutableArray arrayWithObjects:@"首页",@"商城",@"接单",@"租赁",@"我的", nil];
        sonClassVCArray = [NSMutableArray arrayWithObjects:@"HKXHomePageViewController",@"HKXShoppingMallViewController",@"HKXOrderReceivingViewController",@"HKXLeaseViewController",@"HKXMineViewController", nil];
    }
    
    UITabBarController * tabbar = [[UITabBarController alloc] init];
    NSMutableArray * sonViewControllersArray = [NSMutableArray array];
    
    for (int i = 0; i < tabbarArray.count; i ++)
    {
        NSString * titleString = tabbarArray[i];
        //        UITabBarItem * item = [tabbar.tabBar.items objectAtIndex:i ];
        
        //        视图的类名
        Class c = NSClassFromString(sonClassVCArray[i]);
        UIViewController * superViewController = [[c alloc] init];
        
        HKXNavigationController * nc = [[HKXNavigationController alloc] initWithRootViewController:superViewController];
        nc.title = titleString;
        
        [sonViewControllersArray addObject:nc];
        
        UIImage * icoImage = [[UIImage imageNamed:tabbarArray[i]] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        UIImage * icoSelectedImage = [[UIImage imageNamed:[NSString stringWithFormat:@"%@选中",tabbarArray[i]]] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        
        superViewController.tabBarItem = [[UITabBarItem alloc] initWithTitle:titleString image:icoImage selectedImage:icoSelectedImage];
        tabbar.tabBar.tintColor = [CommonMethod getUsualColorWithString:@"#ffa304"];
        
        //        设置导航名字
        //        if ([titleString isEqualToString:@"商城"] || [titleString isEqualToString:@"报修"] || [titleString isEqualToString:@"抢单"] || [titleString isEqualToString:@"租赁"] || [titleString isEqualToString:@"我的"])
        //        {
        if ([titleString isEqualToString:@"接单"])
        {
            superViewController.navigationItem.title = @"接单列表";
        }
        else if ([titleString isEqualToString:@"我的"])
        {
            superViewController.navigationItem.title = @"我的个人中心";
        }
        else
        {
            superViewController.navigationItem.title = titleString;
        }
        //        }
    }
    tabbar.viewControllers = sonViewControllersArray;
    
    
    UIWindow * window = [[[UIApplication sharedApplication] delegate] window];
    
    window.rootViewController = tabbar;
    [window makeKeyWindow];
    AppDelegate * myDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    UIView * backGroundView = [[UIView alloc] initWithFrame:window.bounds];
    backGroundView.backgroundColor = [UIColor darkGrayColor];
    backGroundView.alpha = 0.3;
    backGroundView.tag = 500000;
    [window addSubview:backGroundView];
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGestureClick)];
    [backGroundView addGestureRecognizer:tap];

    CustomAlertView * submitAlertView = [CustomAlertView alertViewWithTitle:[NSString stringWithFormat:@"推荐码：%@",self.userRegisterData.recommendCode] content:@"复制上面信息发送到社交群里您会有小惊喜" cancel:@"完成" sure:@"复制" cancelBtnClick:^{
        [self tapGestureClick];
    } sureBtnClick:^{
        //TODO:此处添加分享部分
        [UMSocialUIManager showShareMenuViewInWindowWithPlatformSelectionBlock:^(UMSocialPlatformType platformType, NSDictionary *userInfo) {
            UMSocialMessageObject *messageObject = [UMSocialMessageObject messageObject];
            //设置文本
            messageObject.text = self.userRegisterData.recommendCode;
            // 根据获取的platformType确定所选平台进行下一步操作
            [[UMSocialManager defaultManager] shareToPlatform:platformType messageObject:messageObject currentViewController:self completion:^(id data, NSError *error) {
                if (error) {
                    UMSocialLogInfo(@"************Share fail with error %@*********",error);
                    [self showHint:@"分享失败"];
                    
                }else{
                    if ([data isKindOfClass:[UMSocialShareResponse class]]) {
                        UMSocialShareResponse *resp = data;
                        //分享结果消息
                        UMSocialLogInfo(@"response message is %@",resp.message);
                        //第三方原始返回的数据
                        UMSocialLogInfo(@"response originalResponse data is %@",resp.originalResponse);
                        
                    }else{
                        UMSocialLogInfo(@"response data is %@",data);
                    }
                }
                
            }];
            
        }];
        [self tapGestureClick];
    } WithAlertHeight:240 * myDelegate.autoSizeScaleY];
    submitAlertView.tag = 500002;
    [window addSubview:submitAlertView];

    
}
#pragma mark - Private Method
- (void)resetMachineInfo
{
    AppDelegate * myDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    for (int i = 0; i < 8; i ++)
    {
        UITextField * tf = [_bottomScrollView viewWithTag:4000 + i];
        tf.text = @"";
    }
    for (UIImageView * imag in self.imageArray)
    {
        imag.image = NULL;
    }
    self.machineModel.category = @"";
    [self tapGestureClick];
//    改变因图片选择而影响底层view的frame
    float length = [CommonMethod getLabelLengthWithString:@"设备照片" WithFont:17 * myDelegate.autoSizeScaleY];
    _bottomScrollView.contentSize = CGSizeMake(ScreenWidth, ScreenHeight - 20 - 60 - 10 * myDelegate.autoSizeScaleY);
    UIButton * addImageBtn = [_bottomScrollView viewWithTag:700];
    addImageBtn.frame = CGRectMake(length + (22 + 17) * myDelegate.autoSizeScaleX , 423 * myDelegate.autoSizeScaleY, 194 / 2 * myDelegate.autoSizeScaleX , 122 / 2 * myDelegate.autoSizeScaleY);
    
    UIButton * submitBtn = [_bottomScrollView viewWithTag:750];
    submitBtn.frame = CGRectMake((ScreenWidth - 274 * myDelegate.autoSizeScaleX) / 2, CGRectGetMaxY(addImageBtn.frame) + 38 * myDelegate.autoSizeScaleY, 274 * myDelegate.autoSizeScaleX, 44 * myDelegate.autoSizeScaleY);
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
- (void)showRecommandCode
{
    //    TODO:此处跳转至首页
    [self createTabbar:self.userRegisterData.role];
    NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
    [defaults setInteger:self.userRegisterData.role forKey:@"userDataRole"];
    [defaults setDouble:self.userRegisterData.dataIdentifier forKey:@"userDataId"];
    [defaults setBool:YES forKey:@"userLoginState"];
    NSArray * arr = [[NSString stringWithFormat:@"%ld",self.userRegisterData.dataIdentifier] componentsSeparatedByString:@"."];
    if ([defaults integerForKey:@"userDataRole"] == 0) {
        
        [UMessage addAlias:arr[0] type:@"HKX_MACHINE" response:^(id  _Nonnull responseObject, NSError * _Nonnull error) {
            
            NSLog(@"%@",responseObject);;
            
        }];
    }else if([defaults integerForKey:@"userDataRole"] == 1){
        
        
        [UMessage addAlias:arr[0] type:@"HKX_REPAIR" response:^(id  _Nonnull responseObject, NSError * _Nonnull error) {
            
            NSLog(@"%@",responseObject);;
            
        }];
    }else if([defaults integerForKey:@"userDataRole"] == 2){
        
        [UMessage addAlias:arr[0] type:@"HKX_SUPPLIER" response:^(id  _Nonnull responseObject, NSError * _Nonnull error) {
            
            NSLog(@"%@",responseObject);;
            
        }];
    }
    [defaults synchronize];
    
    
}
#pragma mark - Delegate & Data Source
- (void)didSelectedOptionInCustomDropDownBtn:(CustomDropDownBtn *)dropDownBtn
{
    UITextField * userTF = [self.view viewWithTag:4001];
    userTF.text = dropDownBtn.selectedTitle;
    
    self.machineModel.category = dropDownBtn.selectedTitle;
    
}
#pragma mark - <CTAssetsPickerControllerDelegate>
- (BOOL)assetsPickerController:(CTAssetsPickerController *)picker shouldSelectAsset:(PHAsset *)asset
{
    NSInteger max = 4;
    if (picker.selectedAssets.count >= max)
    {
        UIAlertController * alert = [UIAlertController alertControllerWithTitle:@"提示" message:[NSString stringWithFormat:@"最多选择%ld张图片",(long)max] preferredStyle:UIAlertControllerStyleAlert];
        [alert addAction:[UIAlertAction actionWithTitle:@"好的" style:UIAlertActionStyleDefault handler:nil]];
        [picker presentViewController:alert animated:YES completion:nil];
        //        这里不能使用self来modal别的控制器，因为此时self.view不在window上
        return NO;
    }
    return YES;
}
- (void)assetsPickerController:(CTAssetsPickerController *)picker didFinishPickingAssets:(NSArray<PHAsset *> *)assets
{
    

    AppDelegate * myDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];

    NSInteger XPosition = (assets.count ) % 2;
    NSInteger YPosition = (assets.count ) / 2;
    //    改变因图片选择而影响底层view的frame
    _bottomScrollView.contentSize = CGSizeMake(ScreenWidth , ScreenHeight - 20 * myDelegate.autoSizeScaleY - 64 + YPosition * (122 + 40)/ 2 * myDelegate.autoSizeScaleY);
    UIButton * addImageBtn = [_bottomScrollView viewWithTag:700];
    if (assets.count < 4)
    {
        float length = [CommonMethod getLabelLengthWithString:@"设备照片" WithFont:17 * myDelegate.autoSizeScaleY];
        
        addImageBtn.frame = CGRectMake((length + (22 + 17) * myDelegate.autoSizeScaleX ) + XPosition * 100 * myDelegate.autoSizeScaleX, 423 * myDelegate.autoSizeScaleY + YPosition * 70 * myDelegate.autoSizeScaleY, 194 / 2 * myDelegate.autoSizeScaleX , 122 / 2 * myDelegate.autoSizeScaleY);
    }
    else
    {
        addImageBtn.hidden = YES;
    }

    UIButton * submitBtn = [_bottomScrollView viewWithTag:750];
    submitBtn.frame = CGRectMake((ScreenWidth - 274 * myDelegate.autoSizeScaleX) / 2, 423 * myDelegate.autoSizeScaleY + 70 *( YPosition + 1)* myDelegate.autoSizeScaleY + 38 * myDelegate.autoSizeScaleY, 274 * myDelegate.autoSizeScaleX, 44 * myDelegate.autoSizeScaleY);
    
    //    关闭图片选择界面
    [picker dismissViewControllerAnimated:YES completion:nil];
    CGFloat scale = [[UIScreen mainScreen] scale];
    PHImageRequestOptions * options = [[PHImageRequestOptions alloc] init];
    options.resizeMode = PHImageRequestOptionsResizeModeExact;
    options.deliveryMode = PHImageRequestOptionsDeliveryModeHighQualityFormat;
    //    遍历选中的图片
    for (NSInteger i = 0; i < assets.count; i ++)
    {
        PHAsset * asset = assets[i];
        CGSize size = CGSizeMake(asset.pixelWidth / scale, asset.pixelHeight / scale);
        //        获取图片
        [[PHImageManager defaultManager] requestImageForAsset:asset targetSize:size contentMode:PHImageContentModeDefault options:options resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
            UIImageView * imageView = self.imageArray[i];
            imageView.hidden = NO;
            imageView.image = result;
            
            NSData * data = UIImageJPEGRepresentation(result, 0.3);
            NSString * dataStr = [data base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
            NSString * typeStr = [self contentTypeForImageData:data];
            __block NSString * imageDataString;
            imageDataString = [NSString stringWithFormat:@"data:image/%@;base64,%@",typeStr,dataStr];
            if (i == 0)
            {
                _baseString = imageDataString;
            }
            else
            {
                NSString * appendString = [NSString stringWithFormat:@"$%@",imageDataString];
                _baseString = [_baseString stringByAppendingString:appendString];
            }
        }];
    }
}
#pragma mark - Setters & Getters
- (HKXOwnerRegisterMachineModel *)machineModel
{
    if (!_machineModel )
    {
        _machineModel = [HKXOwnerRegisterMachineModel getUserModel];
    }
    return _machineModel;
}
- (NSMutableArray *)imageArray
{
    if (!_imageArray)
    {
        _imageArray = [NSMutableArray array];
    }
    return _imageArray;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
