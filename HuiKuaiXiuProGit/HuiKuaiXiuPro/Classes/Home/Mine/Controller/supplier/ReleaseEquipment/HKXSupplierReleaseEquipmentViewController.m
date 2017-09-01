//
//  HKXSupplierReleaseEquipmentViewController.m
//  HuiKuaiXiuPro
//
//  Created by 李金灿 on 2017/7/12.
//  Copyright © 2017年 Lee. All rights reserved.
//

#import "HKXSupplierReleaseEquipmentViewController.h"
#import "CommonMethod.h"
#import "CustomDropDownBtn.h"
#import "CustomSubmitView.h"

#import "HKXHttpRequestManager.h"
#import "HKXEquipmentSpecModel.h"
#import<SDWebImage/UIButton+WebCache.h>
#import "UIImageView+WebCache.h"

#import "SDWebImageManager.h"
#import "SDImageCache.h"


@interface HKXSupplierReleaseEquipmentViewController ()<CustomDropDownDelegate , UITextFieldDelegate ,UIImagePickerControllerDelegate , UINavigationControllerDelegate , UIActionSheetDelegate>
{
    UIScrollView * _bottomScrollView;
    NSString     * _picBase64String;//整机转码之后的图片
}

@property (nonatomic , weak)CustomDropDownBtn * dropDownBtn;
@property (nonatomic , strong) NSMutableArray * equipmentSpecArray;//整机种类数组
@property (nonatomic , strong) NSMutableArray * equipmentBrandArray;//整机名牌数组

@property (nonatomic , strong) UIActionSheet * actionSheet;

@end

@implementation HKXSupplierReleaseEquipmentViewController

#pragma mark - LifeCycle
- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self loadData];
    [self createUI];
}
#pragma mark - CreateUI
- (void)createUI
{
    AppDelegate * myDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    self.view.backgroundColor = [UIColor colorWithRed:235 / 255.0 green:235 / 255.0 blue:235 / 255.0 alpha:1];
    
    
    _bottomScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 10 * myDelegate.autoSizeScaleY, ScreenWidth, ScreenHeight - 20  - 10 * myDelegate.autoSizeScaleY)];
    _bottomScrollView.backgroundColor = [UIColor whiteColor];
    _bottomScrollView.contentSize = CGSizeMake(ScreenWidth, ScreenHeight - 20  - 10 * myDelegate.autoSizeScaleY - 60);
    _bottomScrollView.pagingEnabled = NO;
    _bottomScrollView.bounces = NO;
    [self.view addSubview:_bottomScrollView];
    
    NSArray * placeHolderArray = @[@"设备类型",@"品牌",@"型号",@"关键参数",@"企业名称",@"描述"];
    NSArray * contentArray = [NSArray array];
    
    if (![[NSString stringWithFormat:@"%d",self.equipmentModel.pmaId] isEqualToString:@"0"])
    {
        contentArray = [NSArray arrayWithObjects:self.equipmentModel.type,self.equipmentModel.brand,self.equipmentModel.modelnum,self.equipmentModel.parameter,self.equipmentModel.compname,self.equipmentModel.bewrite, nil];
    }
    for (int i = 0; i < placeHolderArray.count ; i ++)
    {
        UITextField * contentTF = [[UITextField alloc] initWithFrame:CGRectMake(22 * myDelegate.autoSizeScaleX, (10 + (40 + 10) * i) * myDelegate.autoSizeScaleY, 331 * myDelegate.autoSizeScaleX, 40 * myDelegate.autoSizeScaleY)];
        contentTF.borderStyle = UITextBorderStyleRoundedRect;
        contentTF.placeholder = placeHolderArray[i];
        contentTF.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 13 * myDelegate.autoSizeScaleX, contentTF.frame.size.height)];
        contentTF.leftView.backgroundColor = [UIColor clearColor];
        contentTF.leftViewMode = UITextFieldViewModeAlways;
        contentTF.font = [UIFont systemFontOfSize:17 * myDelegate.autoSizeScaleX];
        contentTF.tag = 30000 + i;
        [_bottomScrollView addSubview:contentTF];
        
        if (![[NSString stringWithFormat:@"%d",self.equipmentModel.pmaId] isEqualToString:@"0"])
        {
            contentTF.text = contentArray[i];
            
        }
        if (!self.isEditable)
        {
            contentTF.enabled = NO;
        }
        if (i < 2)
        {
            CustomDropDownBtn * optionBtn = [[CustomDropDownBtn alloc] initWithFrame:CGRectMake(260 * myDelegate.autoSizeScaleX, 0, 72.5 * myDelegate.autoSizeScaleX, contentTF.frame.size.height)];
            if (i == 0)
            {
                optionBtn.array = self.equipmentSpecArray;
            }
            else
            {
                optionBtn.array = self.equipmentBrandArray;
            }
            optionBtn.delegate = self;
            optionBtn.tag = 40000 + i;
            [contentTF addSubview:optionBtn];
            self.dropDownBtn = optionBtn;
            
            if (!self.isEditable)
            {
                optionBtn.hidden = NO;
            }
        }
        
        if (i == placeHolderArray.count - 1)
        {
            UILabel * picLabel = [[UILabel alloc] initWithFrame:CGRectMake(22 * myDelegate.autoSizeScaleX, CGRectGetMaxY(contentTF.frame) + 10 * myDelegate.autoSizeScaleY, 97 * myDelegate.autoSizeScaleX, 17 * myDelegate.autoSizeScaleX)];
            picLabel.text = @"产品图片";
            picLabel.textColor = [CommonMethod getUsualColorWithString:@"#a0a0a0"];
            picLabel.font = [UIFont systemFontOfSize:17 * myDelegate.autoSizeScaleX];
            [_bottomScrollView addSubview:picLabel];
            
            UIButton * goodsPicBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            goodsPicBtn.frame = CGRectMake(22 * myDelegate.autoSizeScaleX, CGRectGetMaxY(picLabel.frame) + 10 * myDelegate.autoSizeScaleY, 97 * myDelegate.autoSizeScaleX, 61 * myDelegate.autoSizeScaleY);
            CAShapeLayer *border = [CAShapeLayer layer];
            border.strokeColor = [CommonMethod getUsualColorWithString:@"#a0a0a0"].CGColor;
            border.fillColor = nil;
            border.path = [UIBezierPath bezierPathWithRect:goodsPicBtn.bounds].CGPath;
            border.frame = goodsPicBtn.bounds;
            border.lineWidth = 0.5;
            border.lineCap = @"square";
            border.lineDashPattern = @[@4, @2];
            [goodsPicBtn.layer addSublayer:border];
            [goodsPicBtn addTarget:self action:@selector(openPhotoLibraryBtnClick:) forControlEvents:UIControlEventTouchUpInside];
            goodsPicBtn.tag = 8990;
            [_bottomScrollView addSubview:goodsPicBtn];
            
            UIImageView * addImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"添加"]];
            addImage.frame = CGRectMake(37.5 * myDelegate.autoSizeScaleX, 20 * myDelegate.autoSizeScaleY, 22 * myDelegate.autoSizeScaleX, 22 * myDelegate.autoSizeScaleX);
            [goodsPicBtn addSubview:addImage];
            if (!self.isEditable )
            {
                addImage.hidden = YES;
            }
            if (![[NSString stringWithFormat:@"%d",self.equipmentModel.pmaId] isEqualToString:@"0"])
            {
                [goodsPicBtn sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",kIMAGEURL,self.equipmentModel.picture]] forState:UIControlStateNormal];
                UIImageView * oldImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
                [oldImage sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",kIMAGEURL,self.equipmentModel.picture]]];
                UIImage * oldImg = oldImage.image;
                NSData * data = UIImageJPEGRepresentation(oldImg, 1.0);
                NSString * dataStr = [data base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
                
                NSString * typeStr = [self contentTypeForImageData:data];
                _picBase64String = [NSString stringWithFormat:@"data:image/%@;base64,%@",typeStr,dataStr];
                [goodsPicBtn addSubview:oldImage];
            }
        }
    }
    
    UITextField * lastTopTF = [_bottomScrollView viewWithTag:30005];
    NSArray * btnTitleArray = @[@"取 消",@"提 交"];
    NSArray * btnBGColorArray = @[@"#e06e15",@"#ffa304"];
    for (int i = 0; i < 2; i ++)
    {
        UIButton * actionBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        actionBtn.frame = CGRectMake((22 + (150 + 31) * i) * myDelegate.autoSizeScaleX, CGRectGetMaxY(lastTopTF.frame) + 222 * myDelegate.autoSizeScaleY, 150 * myDelegate.autoSizeScaleX, 44 * myDelegate.autoSizeScaleY);
        [actionBtn setTitle:btnTitleArray[i] forState:UIControlStateNormal];
        [actionBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        actionBtn.backgroundColor = [CommonMethod getUsualColorWithString:btnBGColorArray[i]];
        actionBtn.tag = 50000 + i;
        [actionBtn addTarget:self action:@selector(actionBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        actionBtn.layer.cornerRadius = 2;
        actionBtn.clipsToBounds = YES;
        [_bottomScrollView addSubview:actionBtn];
        
        if (!self.isEditable )
        {
            actionBtn.hidden = YES;
        }
    }
}
#pragma mark - ConfigData
- (void)loadData
{
    _picBase64String = [[NSString alloc] init];
    [self.view showActivity];
    [HKXHttpRequestManager sendRequestToGetAllEquipmentSpecResult:^(id data) {
        [self.view hideActivity];
        HKXEquipmentSpecModel * model = data;
       
        if (model.success)
        {
            for (NSString * str in model.data)
            {
                [self.equipmentSpecArray addObject:str];
            }

        }
    }];
    [HKXHttpRequestManager sendRequestToGetAllEquipmentBrandResult:^(id data) {
        [self.view hideActivity];
        HKXEquipmentSpecModel * model = data;
        if (model.success)
        {
            for (NSString * str in model.data)
            {
                [self.equipmentBrandArray addObject:str];
            }
            
        }
    }];
    
}
- (void)prepareRequestData
{
    if ([[NSString stringWithFormat:@"%d",self.equipmentModel.pmaId] isEqualToString:@"0"])
    {
        self.equipmentModel = [[HKXSupplierEquipmentManagementData alloc] init];
    }
    //    用户编号
    long userId = [[NSUserDefaults standardUserDefaults] doubleForKey:@"userDataId"];
    self.equipmentModel.mId = userId;
    
//    图片
    
    if ([_picBase64String isEqualToString:@""])
    {
        if (![[NSString stringWithFormat:@"%d",self.equipmentModel.pmaId] isEqualToString:@"0"])
        {
            NSString* strUrl = [NSString stringWithFormat:@"%@%@",kIMAGEURL,self.equipmentModel.picture];
            SDWebImageManager *manager = [SDWebImageManager sharedManager];
            NSString* key = [manager cacheKeyForURL:[NSURL URLWithString:strUrl]];
            SDImageCache* cache = [SDImageCache sharedImageCache];
            //此方法会先从memory中取。
            UIImage * image = [cache imageFromDiskCacheForKey:key];
            
            NSData * data = UIImageJPEGRepresentation(image, 0.3);
            NSString * dataStr = [data base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
            
            NSString * typeStr = [self contentTypeForImageData:data];
            _picBase64String = [NSString stringWithFormat:@"data:image/%@;base64,%@",typeStr,dataStr];
        }
    }
    self.equipmentModel.picture = _picBase64String;
    
    
    
//    类型
    UITextField * specTF = [_bottomScrollView viewWithTag:30000];
    self.equipmentModel.type = [specTF.text isEqualToString:@""] ? (NSString *)[NSNull null] : specTF.text;
    
//    品牌
    UITextField * brandTF = [_bottomScrollView viewWithTag:30001];
    self.equipmentModel.brand = [brandTF.text isEqualToString:@""] ? (NSString *)[NSNull null] : brandTF.text;
//    型号
    UITextField * modelTF = [_bottomScrollView viewWithTag:30002];
    self.equipmentModel.modelnum = [modelTF.text isEqualToString:@""] ? (NSString *)[NSNull null] : modelTF.text;
//    关键参数
    UITextField * paraTF = [_bottomScrollView viewWithTag:30003];
    self.equipmentModel.parameter = [paraTF.text isEqualToString:@""] ? (NSString *)[NSNull null] : paraTF.text;
//    企业名称
    UITextField * companyNameTF = [_bottomScrollView viewWithTag:30004];
    self.equipmentModel.compname = [companyNameTF.text isEqualToString:@""] ? (NSString *)[NSNull null] : companyNameTF.text;
//    描述
    UITextField * discribeTF = [_bottomScrollView viewWithTag:30005];
    self.equipmentModel.bewrite = [discribeTF.text isEqualToString:@""] ? (NSString *)[NSNull null] : discribeTF.text;
    
    
    
}
#pragma mark - Action
- (void)actionBtnClick:(UIButton *)btn
{
    if (btn.tag - 50000 == 0)
    {
        NSLog(@"取消");
        [self.navigationController popViewControllerAnimated:YES];
    }
    else
    {
        NSLog(@"提交");
        [self prepareRequestData];
        
        if ([[NSString stringWithFormat:@"%d",self.equipmentModel.pmaId] isEqualToString:@"0"])
        {
//            新发布
            [HKXHttpRequestManager sendRequestWithSupplierEquipmentInfo:self.equipmentModel ToGetReleaseEquipmentResult:^(id data) {
                HKXEquipmentSpecModel * model = data;
                CustomSubmitView * customAlertView = [CustomSubmitView alertViewWithTitle:@"提示" content:model.message sure:@"确定" sureBtnClick:^{
                    [self tapGestureClick];
                    if (model.success)
                    {
                        [self.navigationController popViewControllerAnimated:YES];
                    }
                } WithAlertHeight:160];
                customAlertView.tag = 501;
                [self.view addSubview:customAlertView];
            }];
        }
        else
        {
//            更新
            NSLog(@"---%ld====%@",self.equipmentModel.mId,self.equipmentModel.bewrite);
            
            [HKXHttpRequestManager sendRequestWithSupplierUpdateEquipmentInfo:self.equipmentModel ToGetUpdateEquipmentResult:^(id data) {
                HKXEquipmentSpecModel * model = data;
                CustomSubmitView * customAlertView = [CustomSubmitView alertViewWithTitle:@"提示" content:model.message sure:@"确定" sureBtnClick:^{
                    [self tapGestureClick];
                    if (model.success)
                    {
                        [self.navigationController popViewControllerAnimated:YES];
                    }
                    
                } WithAlertHeight:160];
                customAlertView.tag = 501;
                [self.view addSubview:customAlertView];
            }];
        }
        
        
    }
}
- (void)openPhotoLibraryBtnClick:(UIButton *)btn
{
    if (!self.isEditable)
    {
        return;
    }
    else
    {
        [self callActionSheetFunc];
    }
    
}
- (void)tapGestureClick
{
    for (UIView * view in self.view.subviews)
    {
        if (view.tag >= 500 && view.tag <= 507 )
        {
            [view removeFromSuperview];
        }
    }
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
        
        UIButton * headImageBtn = [_bottomScrollView viewWithTag:8990];
        [headImageBtn setImage:image forState:UIControlStateNormal];
        
        
        NSData * data = UIImageJPEGRepresentation(image, 0.3);
        NSString * dataStr = [data base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
        
        NSString * typeStr = [self contentTypeForImageData:data];
        _picBase64String = [NSString stringWithFormat:@"data:image/%@;base64,%@",typeStr,dataStr];
        
        
    }];


}

#pragma mark - Delegate & Data Source
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    if (textField.tag == 30000 || textField.tag == 30001)
    {
        return NO;
    }
    else
    {
        return YES;
    }
}
- (void)didSelectedOptionInCustomDropDownBtn:(CustomDropDownBtn *)dropDownBtn
{
    UITextField * userTF = [_bottomScrollView viewWithTag:dropDownBtn.tag - 10000];
    userTF.text = dropDownBtn.selectedTitle;
}
#pragma mark - Setters & Getters
- (NSMutableArray *)equipmentSpecArray
{
    if (!_equipmentSpecArray)
    {
        _equipmentSpecArray = [NSMutableArray array];
    }
    return _equipmentSpecArray;
}
- (NSMutableArray *)equipmentBrandArray
{
    if (!_equipmentBrandArray )
    {
        _equipmentBrandArray = [NSMutableArray array];
    }
    return _equipmentBrandArray;
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
