//
//  HKXMineServeCertificateProfileViewController.m
//  HuiKuaiXiuPro
//
//  Created by 李金灿 on 2017/7/26.
//  Copyright © 2017年 Lee. All rights reserved.
//

#import "HKXMineServeCertificateProfileViewController.h"
#import "CommonMethod.h"
#import "UIImageView+WebCache.h"

#import "HKXHttpRequestManager.h"
#import "HKXMineServeCertificateProfileModelDataModels.h"//证书资料
#import "HKXMyTextView.h"
#import "HKXSeverCollectionViewCell.h"
@interface HKXMineServeCertificateProfileViewController ()<UITextViewDelegate,UIImagePickerControllerDelegate,UIActionSheetDelegate,HKXCollectionCellDelegate,UINavigationControllerDelegate>{
    
    HKXMyTextView * textView;
    UIButton * rightBtn;
    UIButton * submitBtn;
    
    //照片下拉菜单
    UIActionSheet *myActionSheet;
    
    //图片2进制路径
    NSString* filePath;
    
    //选择的图片
    UIImage * equipmentImg;
    
    NSInteger selectedTag;
}

@property (nonatomic , strong) NSArray * serveSpecArray;//主修种类
@property (nonatomic , strong) NSMutableArray * certificateProfileArray;//证书数组
@property (nonatomic , strong) NSMutableArray * tempArr;
@end

@implementation HKXMineServeCertificateProfileViewController

#pragma mark - LifeCycle
- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    
    [self createUI];
    [self loadData];
}
#pragma mark - CreateUI
- (void)createUI
{
    AppDelegate * myDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    self.view.backgroundColor = [UIColor colorWithRed:235 / 255.0 green:235 / 255.0 blue:235 / 255.0 alpha:1];
    
    rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    rightBtn.frame = CGRectMake(0, 0, 40, 40);
    [rightBtn setTitle:@"编辑" forState:UIControlStateNormal];
    [rightBtn setTitle:@"完成" forState:UIControlStateSelected];
    [rightBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [rightBtn addTarget:self action:@selector(rightBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem * right = [[UIBarButtonItem alloc] initWithCustomView:rightBtn];
    //self.navigationItem.rightBarButtonItem = right;
    
    UIView * backView = [[UIView alloc] initWithFrame:CGRectMake(0, 10 * myDelegate.autoSizeScaleY + 60, ScreenWidth, ScreenHeight - 30 * myDelegate.autoSizeScaleY - 60)];
    backView.backgroundColor = [UIColor whiteColor];
    backView.tag = 480;
    [self.view addSubview:backView];
    
//    主修
    float majorServeLabelLength = [CommonMethod getLabelLengthWithString:@"主修" WithFont:17 * myDelegate.autoSizeScaleX];
    UILabel * majorServeLabel = [[UILabel alloc] initWithFrame:CGRectMake(22 * myDelegate.autoSizeScaleX, 16 * myDelegate.autoSizeScaleY, majorServeLabelLength, 17 * myDelegate.autoSizeScaleX)];
    majorServeLabel.text = @"主修";
    majorServeLabel.font = [UIFont systemFontOfSize:17 * myDelegate.autoSizeScaleX];
    [backView addSubview:majorServeLabel];
    
    float serveSpecLabelLength = [CommonMethod getLabelLengthWithString:@"液压系统" WithFont:14 * myDelegate.autoSizeScaleX];
    self.serveSpecArray = @[@"液压系统",@"机械部位",@"发动机",@"电路",@"保养"];
    for (int i = 0; i < self.serveSpecArray.count; i ++)
    {
        int X = i % 3;
        int Y = i / 3;
        UIButton * serveSpecBtn = [[UIButton alloc] initWithFrame:CGRectMake(CGRectGetMaxX(majorServeLabel.frame) + 16 * myDelegate.autoSizeScaleX + X * (38 * myDelegate.autoSizeScaleX + serveSpecLabelLength), 16 * myDelegate.autoSizeScaleY + Y * 49 * myDelegate.autoSizeScaleY, 12 * myDelegate.autoSizeScaleX, 12 * myDelegate.autoSizeScaleX)];
        [serveSpecBtn setImage:[UIImage imageNamed:@"复选框-未选中"] forState:UIControlStateNormal];
        [serveSpecBtn setImage:[UIImage imageNamed:@"复选框_已选择"] forState:UIControlStateSelected];
        serveSpecBtn.selected = NO;
        serveSpecBtn.tag = 30000 + i;
        [serveSpecBtn addTarget:self action:@selector(selectTroubleBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [backView addSubview:serveSpecBtn];
        
        UILabel * serveSpecLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(serveSpecBtn.frame) + 10 * myDelegate.autoSizeScaleX, serveSpecBtn.frame.origin.y, serveSpecLabelLength, 14 * myDelegate.autoSizeScaleX)];
        serveSpecLabel.text = self.serveSpecArray[i];
        serveSpecLabel.font = [UIFont systemFontOfSize:14 * myDelegate.autoSizeScaleX];
        [backView addSubview:serveSpecLabel];
    }
    
//    技能描述
    textView = [[HKXMyTextView alloc] initWithFrame:CGRectMake(22 * myDelegate.autoSizeScaleX, 102 * myDelegate.autoSizeScaleY , ScreenWidth - 44 * myDelegate.autoSizeScaleX, 40 * myDelegate.autoSizeScaleY)];
    textView.delegate = self;
    textView.tag = 7000;
    textView.font = [UIFont systemFontOfSize:17 * myDelegate.autoSizeScaleX];
    textView.tag = 676767;
    textView.layer.borderColor = [UIColor grayColor].CGColor;
    textView.layer.borderWidth = 0.5;
    textView.layer.cornerRadius = 4.0f;
    textView.layer.masksToBounds = YES;
    textView.placeholder = @"简要输入个人技能描述";
    textView.placeholderColor = [UIColor lightGrayColor];
    textView.verticalSpacing = 10;
    textView.textContainerInset = UIEdgeInsetsMake(15, 10, 15, 10);
    textView.textViewAutoHeight = ^(CGFloat height){
    };
    textView.maxHeight = 140 * myDelegate.autoSizeScaleY;
    textView.minHeight = 35 * myDelegate.autoSizeScaleY;
    textView.backgroundColor = [UIColor whiteColor];
   
    [backView addSubview:textView];
    
    
    
//    UITextField * skillTF = [[UITextField alloc] initWithFrame:CGRectMake(22 * myDelegate.autoSizeScaleX, 102 * myDelegate.autoSizeScaleY , ScreenWidth - 44 * myDelegate.autoSizeScaleX, 40 * myDelegate.autoSizeScaleY)];
//    skillTF.tag = 7000;
//    skillTF.font = [UIFont systemFontOfSize:17 * myDelegate.autoSizeScaleX];
//    skillTF.placeholder = @"简要输入个人技能描述";
//    skillTF.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10 * myDelegate.autoSizeScaleX, skillTF.frame.size.height)];
//    skillTF.leftView.backgroundColor = [UIColor clearColor];
//    skillTF.leftViewMode = UITextFieldViewModeAlways;
//    skillTF.borderStyle = UITextBorderStyleRoundedRect;
//    [backView addSubview:skillTF];
    
//    证书
    UILabel * certificateLabel = [[UILabel alloc] init];
    certificateLabel.tag = 787877;
    certificateLabel.text = @"证书";
    certificateLabel.font = [UIFont systemFontOfSize:17 * myDelegate.autoSizeScaleX];
    [backView addSubview:certificateLabel];
    
    submitBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    submitBtn = [[UIButton alloc] initWithFrame:CGRectMake(ScreenWidth / 4 , ScreenHeight - 64 - 40 *  myDelegate.autoSizeScaleY - 30 *  myDelegate.autoSizeScaleY, ScreenWidth / 2, 40 *  myDelegate.autoSizeScaleY)];
    [submitBtn setTitle:@"保 存" forState:UIControlStateNormal];
    [submitBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [submitBtn setBackgroundColor:[UIColor orangeColor]];
    submitBtn.layer.cornerRadius = 4.0f;
    submitBtn.layer.borderColor = [[UIColor orangeColor] CGColor];
    submitBtn.layer.borderWidth = 0.5f;
    [submitBtn addTarget:self action:@selector(submit:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:submitBtn];
}
#pragma mark - ConfigData
- (void)loadData
{
    AppDelegate * myDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    UIView * backView = [self.view viewWithTag:480];
    long userId = [[NSUserDefaults standardUserDefaults] doubleForKey:@"userDataId"];
    [self.view showActivity];
    [HKXHttpRequestManager sendRequestWithUserId:[NSString stringWithFormat:@"%ld",userId] ToGetUserCertificateProfileResult:^(id data) {
        [self.view hideActivity];
        HKXMineServeCertificateProfileModel * model = data;
        if (model.success)
        {
            for (int btnTag = 30000; btnTag < 30005; btnTag ++)
            {
                NSString * majorString = [NSString stringWithFormat:@"%d",btnTag - 30000];
                
                if ([model.data.majorMachine rangeOfString:majorString].location != NSNotFound)
                {
                
                    UIButton * btn = [backView viewWithTag:btnTag];
                    btn.selected = YES;
                }
            }
           
            textView.text = model.data.profile;
            //textView.userInteractionEnabled = NO;
            float majorServeLabelLength = [CommonMethod getLabelLengthWithString:@"主修" WithFont:17 * myDelegate.autoSizeScaleX];
            UILabel * lb = [backView viewWithTag:787877];
            lb.frame = CGRectMake(22 * myDelegate.autoSizeScaleX, CGRectGetMaxY(textView.frame) + 23 * myDelegate.autoSizeScaleY, majorServeLabelLength, 17 * myDelegate.autoSizeScaleX);
            [self.certificateProfileArray removeAllObjects];
            self.certificateProfileArray = (NSMutableArray *)model.data.credentials;
            
            
            float lengthh = [CommonMethod getLabelLengthWithString:@"主修" WithFont:17 * myDelegate.autoSizeScaleY];
            UICollectionViewFlowLayout *flowLayout=[[UICollectionViewFlowLayout alloc] init];
            
            self.collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake((lengthh + (22 + 17) * myDelegate.autoSizeScaleX ) , CGRectGetMaxY(textView.frame) + 23 * myDelegate.autoSizeScaleY ,2 * 97 * myDelegate.autoSizeScaleX, 5 * 61 * myDelegate.autoSizeScaleY) collectionViewLayout:flowLayout];
            //设置代理
            self.collectionView.delegate = self;
            self.collectionView.dataSource = self;
            [backView addSubview:self.collectionView];
            self.collectionView.backgroundColor = [UIColor whiteColor];
            //注册cell和ReusableView（相当于头部）
            [self.collectionView registerClass:[HKXSeverCollectionViewCell class] forCellWithReuseIdentifier:@"cell"];
            _tempArr = [[NSMutableArray alloc] init];
            for (int i = 0; i < self.certificateProfileArray.count; i ++) {
                
               // [_tempArr addObject:[UIImage imageNamed:@"挖掘机"]];
                [_tempArr addObject:[UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",kIMAGEURL,self.certificateProfileArray[i]]]]]];
            }
            
            return ;
            
            self.tempArr = [[NSMutableArray alloc] init];
            for (int i = 0; i < self.certificateProfileArray.count; i ++){
                
                UIImage * image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",kIMAGEURL,self.certificateProfileArray[i]]]]];
                NSData *data = UIImageJPEGRepresentation(image, 0.3);
                NSString *picture = [data base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
                NSString * imageDataString;
                if (i == 0) {
                    
                imageDataString = [NSString stringWithFormat:@"data:image/%@;base64,%@",[self contentTypeForImageData:data],picture];
                }else{
                    
                imageDataString = [NSString stringWithFormat:@"image/%@;base64,%@",[self contentTypeForImageData:data],picture];
                }
                [_tempArr addObject:imageDataString];
            }
        }
    }];
}



- (void)textViewDidChange:(UITextView *)text{
    
    AppDelegate * myDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
     UIView * backView = [self.view viewWithTag:480];

    for (int i = 0; i < 5; i ++) {
        
        int y = i / 2;
        UIImageView * image = [backView viewWithTag:787878 + i];
        CGRect frame = image.frame;
        frame.origin.y = CGRectGetMaxY(text.frame) + 23 * myDelegate.autoSizeScaleY + y * 70 * myDelegate.autoSizeScaleY;
        image.frame = frame;
    }
    
    UILabel * lable = [backView viewWithTag:787877];
    CGRect frame = lable.frame;
    frame.origin.y = CGRectGetMaxY(text.frame) + 23 * myDelegate.autoSizeScaleY;
    lable.frame = frame;
    
    
    CGRect frame1 = _collectionView.frame;
   
    frame1.origin.y = CGRectGetMaxY(text.frame) + 23 * myDelegate.autoSizeScaleY;
    _collectionView.frame = frame1;
}

- (void)choosePicture{
    
    NSLog(@"打开系统相册");
    NSLog(@"选择照片");
    myActionSheet = [[UIActionSheet alloc]
                     initWithTitle:nil
                     delegate:self
                     cancelButtonTitle:@"取消"
                     destructiveButtonTitle:nil
                     otherButtonTitles:@"从手机相册获取",@"拍照",nil];
    
    [myActionSheet showInView:self.view];
    
}

- (void)rightBtnClick:(UIButton *)rBtn{
    
    
    rBtn.selected = !rBtn.selected;
    UIView * backView = [self.view viewWithTag:480];
    
    if (rBtn.selected) {
        
        NSLog(@"编辑模式");
        
        for (int i = 0; i < 5; i ++) {
            
            UIButton * btn = [backView viewWithTag:i + 30000];
            btn.userInteractionEnabled = YES;
        }
        
        submitBtn.hidden = NO;
        
    }else{
        
        NSLog(@"展示模式");
        for (int i = 0; i < 5; i ++) {
            
            UIButton * btn = [backView viewWithTag:i + 30000];
            btn.userInteractionEnabled = NO;
        }
        submitBtn.hidden = YES;
    }
    
    
}

- (void)selectTroubleBtnClick:(UIButton *)btn{
    
    btn.selected = !btn.selected;
}

- (void)submit:(UIButton *)submit{
    
    
    //textView.text
    UIButton * hydraulicPressureBtn =[self.view viewWithTag:30000];
    UIButton * machineryPartBtn =[self.view viewWithTag:30001];
    UIButton * engineBtn =[self.view viewWithTag:30002];
    UIButton * circuitBtn =[self.view viewWithTag:30003];
    UIButton * maintenanceBtn =[self.view viewWithTag:30004];
    
    NSString * hydraulicPressure;
    NSString * machineryPart;
    NSString * engine;
    NSString * circuit;
    NSString * maintenance;
    NSMutableArray * faultTypeArr = [[NSMutableArray alloc] init];
    if (hydraulicPressureBtn.selected) {
        
        hydraulicPressure  = @"0";
        [faultTypeArr addObject:hydraulicPressure];
    }
    if (machineryPartBtn.selected) {
        
        machineryPart  = @"1";
        [faultTypeArr addObject:machineryPart];
    }
    if (engineBtn.selected) {
        
        engine  = @"2";
        [faultTypeArr addObject:engine];
    }
    if (circuitBtn.selected) {
        
        circuit  = @"3";
        [faultTypeArr addObject:circuit];
    }
    if (maintenanceBtn.selected) {
        
        maintenance  = @"4";
        [faultTypeArr addObject:maintenance];
    }
    if (faultTypeArr.count == 0) {
        
        [self showHint:@"请选择主修种类"];
        return;
    }
    if (textView.text.length == 0) {
        
        [self showHint:@"请填入个人描述"];
        return;
    }
    if (_tempArr.count == 0) {
        
        [self showHint:@"请添加证书照片"];
        return;
    }
    
    NSString * majorMachine = [faultTypeArr componentsJoinedByString:@","];
    
    NSString *string = [_tempArr componentsJoinedByString:@","];
    NSLog(@"=====%@",string);
    NSMutableArray * picArr = [[NSMutableArray alloc] init];
    for (int i = 0 ; i < _tempArr.count; i ++) {
        
        NSData *data = UIImageJPEGRepresentation(_tempArr[i], 0.3);
        NSString *picture = [data base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
        NSString * imageDataString = [NSString stringWithFormat:@"data:image/%@;base64,%@",[self contentTypeForImageData:data],picture];
        [picArr addObject:imageDataString];
    }
    
    NSString * pic = [picArr componentsJoinedByString:@"$"];
    //保存修改内容
    NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
    double uId = [defaults doubleForKey:@"userDataId"];
    NSInteger roleId = [defaults integerForKey:@"userDataRole"];
    NSDictionary * dict = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithDouble:uId],@"id",[NSNumber numberWithInteger:roleId],@"role",@"",@"photo",@"",@"idCode",majorMachine,@"majorMachine",textView.text,@"profile",pic,@"img",nil];
    NSLog(@"%@",dict);
//    用户Id:id
//    角色类型：role
//    头像：photo
//    身份证号：idCode
//    主修机器：majorMachine
//    个人描述：profile
//    证书图片：img

    
    [self.view showActivity];

    [IWHttpTool postWithUrl:[NSString stringWithFormat:@"%@%@",kBASICURL,@"info/repair.do"] params:dict success:^(id responseObject) {
        
        NSDictionary *dicts =[NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        NSLog(@"请求成功%@",dicts);
        [self.view hideActivity];
        if ([dicts[@"success"] boolValue] == YES) {
            
            [self showHint:@"修改成功"];
            [self.navigationController popViewControllerAnimated:YES];
            
            
        }else if ([dicts[@"success"] boolValue] == NO) {
            
            [self showHint:dicts[@"message"]];
        }
        
        
    } failure:^(NSError *error) {
        
        NSLog(@"请求失败%@",error);
        [self.view hideActivity];
        [self showHint:@"请求失败"];
    }];
    

}


- (void)openPhotoLibraryBtnClick:(UIButton *)btn
{
    NSLog(@"打开系统相册");
    NSLog(@"选择照片");
    myActionSheet = [[UIActionSheet alloc]
                     initWithTitle:nil
                     delegate:self
                     cancelButtonTitle:@"取消"
                     destructiveButtonTitle:nil
                     otherButtonTitles:@"从手机相册获取",@"拍照",nil];
    
    [myActionSheet showInView:self.view];
    
}
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    
    //呼出的菜单按钮点击后的响应
    if (buttonIndex == myActionSheet.cancelButtonIndex)
    {
        NSLog(@"取消");
    }
    
    switch (buttonIndex)
    {
        case 0:  //打开照相机拍照
            [self LocalPhoto];
            break;
            
        case 1:  //打开本地相册
            [self takePhoto];
            break;
    }
}

//开始拍照
-(void)takePhoto
{
    UIImagePickerControllerSourceType sourceType = UIImagePickerControllerSourceTypeCamera;
    if ([UIImagePickerController isSourceTypeAvailable: UIImagePickerControllerSourceTypeCamera])
    {
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        picker.delegate = self;
        //设置拍照后的图片可被编辑
        picker.allowsEditing = YES;
        picker.sourceType = sourceType;
        //  [self presentModalViewController:picker animated:YES];
        [self presentViewController:picker animated:YES completion:nil];
    }else
    {
        NSLog(@"模拟其中无法打开照相机,请在真机中使用");
    }
}

//打开本地相册
-(void)LocalPhoto
{
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    picker.delegate = self;
    //设置选择后的图片可被编辑
    picker.allowsEditing = YES;
    //[self presentModalViewController:picker animated:YES];
    [self presentViewController:picker animated:YES completion:nil];
    
}

//当选择一张图片后进入这里
-(void)imagePickerController:(UIImagePickerController*)picker didFinishPickingMediaWithInfo:(NSDictionary *)info

{
    
    NSString *type = [info objectForKey:UIImagePickerControllerMediaType];
    
    //当选择的类型是图片
    if ([type isEqualToString:@"public.image"])
    {
        //先把图片转成NSData
        UIImage* image = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
        NSData *data;
        if (UIImagePNGRepresentation(image) == nil)
        {
            data = UIImageJPEGRepresentation(image, 1.0);
        }
        else
        {
            data = UIImagePNGRepresentation(image);
        }
        
        //图片保存的路径
        //这里将图片放在沙盒的documents文件夹中
        NSString * DocumentsPath = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
        
        //文件管理器
        NSFileManager *fileManager = [NSFileManager defaultManager];
        
        //把刚刚图片转换的data对象拷贝至沙盒中 并保存为image.png
        [fileManager createDirectoryAtPath:DocumentsPath withIntermediateDirectories:YES attributes:nil error:nil];
        [fileManager createFileAtPath:[DocumentsPath stringByAppendingString:@"/image.png"] contents:data attributes:nil];
        
        //得到选择后沙盒中图片的完整路径
        filePath = [[NSString alloc]initWithFormat:@"%@%@",DocumentsPath,  @"/image.png"];
        [self sendInfo];
        //关闭相册界面
        //[picker dismissModalViewControllerAnimated:YES];
        [picker dismissViewControllerAnimated:YES completion:^{
            
        }];
        //创建一个选择后图片的小图标放在下方
        //类似微薄选择图后的效果
        //        UIImageView *smallimage = [[UIImageView alloc] initWithFrame:
        //                                    CGRectMake(50, 120, 40, 40)];
        //
        //        smallimage.image = image;
        UIImage *imageSelected =[info objectForKey:UIImagePickerControllerEditedImage];
        [self.tempArr addObject:imageSelected];
        [_collectionView reloadData];
        [picker dismissViewControllerAnimated:YES completion:nil];
        //    if (data == nil) {
        //
        //        [self showHint:@"请选择照片!"];
        //        [CustomAlertView hideHUDForView:self];
        //        return;
        //    }
        // NSData *data = UIImagePNGRepresentation(icon);
        //[btn setTitle:@"" forState:UIControlStateNormal];
        //加在视图中
        //[self.view addSubview:smallimage];
        
    }
    
}

- (void)deleBtnClick:(UIButton *)dele{
    
    
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    NSLog(@"您取消了选择图片");
    //[picker dismissModalViewControllerAnimated:YES];
    [picker dismissViewControllerAnimated:YES completion:nil];
}

-(void)sendInfo
{
    NSLog(@"图片的路径是：%@", filePath);
    equipmentImg = [[UIImage alloc] initWithContentsOfFile:filePath];
    
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

#pragma mark - Action
#pragma mark - Private Method
#pragma mark - Delegate & Data Source
#pragma mark - Setters & Getters
- (NSArray *)serveSpecArray
{
    if (!_serveSpecArray)
    {
        _serveSpecArray = [NSArray array];
    }
    return _serveSpecArray;
}
- (NSMutableArray *)certificateProfileArray
{
    if (!_certificateProfileArray)
    {
        _certificateProfileArray = [NSMutableArray array];
    }
    return _certificateProfileArray;
}

#pragma mark -- UICollectionViewDataSource
//定义展示的UICollectionViewCell的个数
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if (self.tempArr.count < 5) {
        
        return self.tempArr.count + 1;
    }else{
        
        return self.tempArr.count;
    }
    
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
    if (indexPath.row < _tempArr.count) {
        
        cell.imgView.image = [_tempArr objectAtIndex:indexPath.row];
        cell.close.hidden = NO;
    }else{
        
        cell.imgView.image = [UIImage imageNamed:@"添加"];
        cell.close.hidden = YES;
    }
    
    //    cell.text.text = [NSString stringWithFormat:@"Cell %ld",indexPath.row];
    cell.delegate = self;
    
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
    
    
    return CGSizeMake((2 * 80 * myDelegate.autoSizeScaleX)/2, (2 * 80 * myDelegate.autoSizeScaleX )/ 2);
}
//定义每个UICollectionView 的间距
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(0, 0, 5, 5);
}
//定义每个UICollectionView 纵向的间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    
    return 0;
}
#pragma mark --UICollectionViewDelegate
//UICollectionView被选中时调用的方法
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    //        UICollectionViewCell * cell = (UICollectionViewCell *)[collectionView cellForItemAtIndexPath:indexPath];
    //        cell.backgroundColor = [UIColor redColor];
    if (indexPath.row == _tempArr.count) {
        
        
        [self choosePicture];
    }
    NSLog(@"选择%ld",indexPath.row);
}
//返回这个UICollectionView是否可以被选择
-(BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    return YES;
}

-(void)moveImageBtnClick:(HKXSeverCollectionViewCell *)aCell{
    
    NSIndexPath * indexPath = [self.collectionView indexPathForCell:aCell];
    NSLog(@"_____%ld",indexPath.row);
    [_tempArr removeObjectAtIndex:indexPath.row];
    [self.collectionView reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
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
