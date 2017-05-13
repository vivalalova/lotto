//
//  EditInfoVC.m
//  LDLiveProject
//
//  Created by MAC on 16/6/20.
//  Copyright © 2016年 MAC. All rights reserved.
//

#import "EditInfoVC.h"
#import "EditYourProfileVC.h"
#import "EditGenderVC.h"
#import "ModifyBulletinVC.h"
#import "RSKImageCropViewController.h"

#import "HXProvincialCitiesCountiesPickerview.h"
#import "HXAddressManager.h"
#import "WoodPickView.h"
#import "DatePickView.h"
#import "ModifyProfessionVC.h"

@interface EditInfoVC ()<UITableViewDelegate,UITableViewDataSource,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UIAlertViewDelegate,UIActionSheetDelegate,RSKImageCropViewControllerDelegate,WoodPickViewDelegate,DatePickViewDelegate,ModifyProfessionVCDelegate>
{
    UITableView *mTableView;
    UserModel   *_userModel;
    WebImageView *wImageV;
}
//城市
@property (nonatomic,strong) HXProvincialCitiesCountiesPickerview *regionPickerView;

@end

@implementation EditInfoVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUsualNavigationBarWithBackAndTitleWithString:@"编辑资料"];
    _userModel = [AccountHelper userInfo];

    mTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT-64)];
    mTableView.dataSource = self;
    mTableView.delegate = self;
    [mTableView setSeparatorColor:[UIColor colorWithHexString:@"0xdadada"]];
    mTableView.backgroundColor = [UIColor colorWithHexString:SystemGroundColor];
    [self.view addSubview:mTableView];
    self.view.backgroundColor = [UIColor colorWithHexString:SystemGroundColor];
    mTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    // Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [mTableView reloadData];
}

- (void)actionClickNavigationBarLeftButton
{
    [super actionClickNavigationBarLeftButton];
    self.navigationController.navigationBar.hidden = YES;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return 1;
    }else if (section == 1){
        return 4;
    }else if (section == 2){
        return 4;
    }else{
        return 0;
    }
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        return 60;
    }else{
        return 44;
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 10;
}

-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 10)];
    view.backgroundColor = [UIColor colorWithHexString:SystemGroundColor];
    return view;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        UITableViewCell *cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
        cell.textLabel.text = @"头像";
        cell.textLabel.textColor = [UIColor colorWithHexString:@"0X333"];
        cell.textLabel.font = [UIFont systemFontOfSize:14];
        
        UIView *view = [[UIView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-53, 6, 43, 43)];
        view.backgroundColor = [UIColor colorWithHexString:@"0xea6e69"];
        view.layer.cornerRadius = view.width/2;
        view.clipsToBounds = YES;
        [cell addSubview:view];
        
        wImageV = [[WebImageView alloc]initWithFrame:CGRectMake(1.5, 1.5, 40, 40)];
        wImageV.layer.cornerRadius = wImageV.width/2;
        wImageV.clipsToBounds = YES;
        [wImageV setImageWithUrlString:_userModel.headportrait placeholderImage:[UIImage imageNamed:@"150a.png"]];
        [view addSubview:wImageV];

        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }else if (indexPath.section == 1){
        if (indexPath.row == 0) {
            UITableViewCell *cell = [self SetupUsualTableViewCellWithString:@"昵称"];
            
            UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-28-200, 0, 200, 44)];
            label.textColor = [UIColor colorWithHexString:@"0xea6e69"];
            label.font = [UIFont systemFontOfSize:14];
            label.textAlignment = NSTextAlignmentRight;
            label.text = _userModel.nick;
            [cell addSubview:label];
            
            UILabel *lineLabel = [[UILabel alloc]initWithFrame:CGRectMake(17, 43.5, SCREEN_WIDTH-20, 0.5)];
            lineLabel.backgroundColor = UIColorFromRGB(230, 230, 230);
            [cell addSubview:lineLabel];
            return cell;
        }else if (indexPath.row == 1){
            UITableViewCell *cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
            cell.textLabel.text = @"房间号";
            cell.textLabel.textColor = [UIColor blackColor];
            cell.textLabel.font = [UIFont systemFontOfSize:14];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-18-200, 0, 200, 44)];
            label.textColor = [UIColor colorWithHexString:@"0xea6e69"];
            label.font = [UIFont systemFontOfSize:14];
            label.textAlignment = NSTextAlignmentRight;
            label.text = _userModel.room_id;
            [cell addSubview:label];
            UILabel *lineLabel = [[UILabel alloc]initWithFrame:CGRectMake(17, 43.5, SCREEN_WIDTH-20, 0.5)];
            lineLabel.backgroundColor = UIColorFromRGB(230, 230, 230);
            [cell addSubview:lineLabel];
            return cell;
        }else if (indexPath.row == 2){
            UITableViewCell *cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
            cell.textLabel.text = @"性别";
            cell.textLabel.textColor = [UIColor blackColor];
            cell.textLabel.font = [UIFont systemFontOfSize:14];
            UIImageView *imagev= [[UIImageView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-15 -16, 15, 14, 14)];
            if ([_userModel.gender intValue]) {
                imagev.image = [UIImage imageNamed:@"edit_man"];
            }else{
                imagev.image = [UIImage imageNamed:@"edit_woman"];
            }
            [cell addSubview:imagev];
            UILabel *lineLabel = [[UILabel alloc]initWithFrame:CGRectMake(17, 43.5, SCREEN_WIDTH-20, 0.5)];
            lineLabel.backgroundColor = UIColorFromRGB(230, 230, 230);
            [cell addSubview:lineLabel];
            return cell;
        }else if (indexPath.row == 3){
            UITableViewCell *cell = [self SetupUsualTableViewCellWithString:@"个性签名"];
            return cell;
        }
    }else if (indexPath.section == 2){
        if (indexPath.row == 0) {
            UITableViewCell *cell;
            if ([NSString isBlankString:_userModel.birth]) {
                cell = [self SetupUsualMoreTableViewCellWithString:@"生日" modelStr:@"你猜"];
            }else{
                cell = [self SetupUsualMoreTableViewCellWithString:@"生日" modelStr:_userModel.birth];
            }
            UILabel *lineLabel = [[UILabel alloc]initWithFrame:CGRectMake(17, 43.5, SCREEN_WIDTH-20, 0.5)];
            lineLabel.backgroundColor = UIColorFromRGB(230, 230, 230);
            [cell addSubview:lineLabel];
            return cell;
        }else if (indexPath.row == 1){
            UITableViewCell *cell;
            if ([NSString isBlankString:_userModel.mood]) {
                cell = [self SetupUsualMoreTableViewCellWithString:@"情感状况" modelStr:@"保密"];
            }else{
                cell = [self SetupUsualMoreTableViewCellWithString:@"情感状况" modelStr:_userModel.mood];
            }
            UILabel *lineLabel = [[UILabel alloc]initWithFrame:CGRectMake(17, 43.5, SCREEN_WIDTH-20, 0.5)];
            lineLabel.backgroundColor = UIColorFromRGB(230, 230, 230);
            [cell addSubview:lineLabel];
            return cell;
        }else if (indexPath.row == 2){
            UITableViewCell *cell;
            if ([NSString isBlankString:_userModel.hometown]) {
                cell = [self SetupUsualMoreTableViewCellWithString:@"家乡" modelStr:@"火星"];
            }else{
                cell = [self SetupUsualMoreTableViewCellWithString:@"家乡" modelStr:_userModel.hometown];
            }
            UILabel *lineLabel = [[UILabel alloc]initWithFrame:CGRectMake(17, 43.5, SCREEN_WIDTH-20, 0.5)];
            lineLabel.backgroundColor = UIColorFromRGB(230, 230, 230);
            [cell addSubview:lineLabel];
            return cell;
        }else if (indexPath.row == 3){
            UITableViewCell *cell;
            if ([NSString isBlankString:_userModel.profession]) {
                cell = [self SetupUsualMoreTableViewCellWithString:@"职业" modelStr:@"主播"];
            }else{
                cell = [self SetupUsualMoreTableViewCellWithString:@"职业" modelStr:_userModel.profession];
            }
            return cell;
        }
    }
    return [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
}

-(UITableViewCell*)SetupUsualTableViewCellWithString:(NSString*)str
{
    UITableViewCell *cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    cell.textLabel.text = str;
    cell.textLabel.textColor = [UIColor blackColor];
    cell.textLabel.font = [UIFont systemFontOfSize:14];
    
    UIImageView *imageV = [[UIImageView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-32+10, 15, 8, 14)];
    imageV.image = [UIImage imageNamed:@"returndown.png"];
    [cell addSubview:imageV];
    return cell;
}

-(UITableViewCell*)SetupUsualMoreTableViewCellWithString:(NSString*)str modelStr:(NSString*)modelStr
{
    UITableViewCell *cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    cell.textLabel.text = str;
    cell.textLabel.textColor = [UIColor blackColor];
    cell.textLabel.font = [UIFont systemFontOfSize:14];
    
    UIImageView *imageV = [[UIImageView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-32+10, 15, 8, 14)];
    imageV.image = [UIImage imageNamed:@"returndown.png"];
    [cell addSubview:imageV];
    
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-32+10-160-4, 0, 160, 44)];
    label.backgroundColor = [UIColor clearColor];
    label.font = [UIFont systemFontOfSize:14];
    label.textAlignment = NSTextAlignmentRight;
    label.text = modelStr;
    [cell addSubview:label];
    
    return cell;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            UIActionSheet *menu=[[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"拍照",@"从手机相册选择", nil];
            menu.actionSheetStyle=UIActionSheetStyleDefault;
            [menu showInView:self.view];
        }
    }
    if (indexPath.section == 1) {
        if (indexPath.row == 0) {
            EditYourProfileVC *edivVC = [[EditYourProfileVC alloc]init];
            [self.navigationController pushViewController:edivVC animated:YES];
        }else if (indexPath.row == 1){
            //房间号
        }else if (indexPath.row == 2){
            EditGenderVC *edVC = [[EditGenderVC alloc]init];
            [self.navigationController pushViewController:edVC animated:YES];
        }else if (indexPath.row == 3){
            //房间公告
            ModifyBulletinVC *ovc=[[ModifyBulletinVC alloc]init];
            [self.navigationController pushViewController:ovc animated:YES];
        }
    }
    
    if (indexPath.section == 2) {
        if (indexPath.row == 0) {
            DatePickView *datePickView = [[DatePickView alloc]initWithFrame:self.view.frame];
            datePickView.delegate = self;
            if ([NSString isBlankString:_userModel.birth]) {
                [datePickView showInView:self.view withSelectStr:@"保密"];
            }else{
                [datePickView showInView:self.view withSelectStr:_userModel.birth];
            }
            
        }else if (indexPath.row == 1){
            //
            WoodPickView *woodPickView = [WoodPickView viewFromXIB];
            woodPickView.width = SCREEN_WIDTH;
            woodPickView.height = SCREEN_HEIGHT;
            woodPickView.delegate = self;
            if ([NSString isBlankString:_userModel.mood]) {
                [woodPickView showInView:self.view withSelectStr:@"保密"];
            }else{
                [woodPickView showInView:self.view withSelectStr:_userModel.mood];
            }
            
        }else if (indexPath.row == 2){
            NSString *address = _userModel.hometown;
            NSArray *array = [address componentsSeparatedByString:@" "];
            
            NSString *province = @"";//省
            NSString *city = @"";//市
            if (array.count > 1) {
                province = array[0];
                city = array[1];
            } else if (array.count > 0) {
                province = array[0];
            }
            [self.regionPickerView showPickerWithProvinceName:province cityName:city];
        }else if (indexPath.row == 3){
            //房间公告
            ModifyProfessionVC *mvc=[[ModifyProfessionVC alloc]init];
            mvc.delegate = self;
            [self.navigationController pushViewController:mvc animated:YES];
        }
    }
}


-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(buttonIndex==0){
        [self snapImage];
    }else if(buttonIndex==1){
        [self pickImage];
    }
}

- (void)snapImage{
    
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        UIImagePickerController * picker = [[UIImagePickerController alloc]init];
        picker.delegate = self;
        picker.allowsEditing=NO;
        //打开相册选择照片
        picker.sourceType = UIImagePickerControllerSourceTypeCamera;
        [self presentViewController:picker animated:YES completion:nil];
        
    }else{
        NSString *tips = [NSString stringWithFormat:@"请在iPhone的”设置-隐私-相机“选项中，允许\"秀播高尔夫\"访问你的手机相机"];
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:tips delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [alert show];
    }
    
}
//从相册里找
- (void)pickImage{
    //相册是可以用模拟器打开的
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) {
        UIImagePickerController * picker = [[UIImagePickerController alloc]init];
        picker.delegate = self;
        
        //打开相册选择照片
        picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        [self presentViewController:picker animated:YES completion:nil];
        
    }else{
        NSString *tips = [NSString stringWithFormat:@"请在iPhone的”设置-隐私-相册“选项中，允许\"秀播高尔夫\"访问你的手机相册"];
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:tips delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [alert show];
    }
}
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    //
    NSLog(@"info~~%@",info);
    
    UIImage*image=[info objectForKey:UIImagePickerControllerOriginalImage];
//    _headerImageView.image = image;
    //    //读取用户隐私，包含经纬度 创建时间
    //    NSURL*url=[info objectForKey:UIImagePickerControllerReferenceURL];
    //    //添加一个系统库
    //    ALAssetsLibrary *ass=[[ALAssetsLibrary alloc]init];
    //    [ass assetForURL:url resultBlock:^(ALAsset *asset) {
    //        //获取图片隐私
    //        NSLog(@"%@",asset.defaultRepresentation.metadata);
    //
    //    } failureBlock:nil];
    
    [picker dismissViewControllerAnimated:YES completion:nil];
    RSKImageCropViewController *imageCropVC = [[RSKImageCropViewController alloc] initWithImage:image cropMode:RSKImageCropModeSquare];
    imageCropVC.delegate = self;
    [self presentViewController:imageCropVC animated:YES completion:nil];
}
//取消
-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:YES completion:nil];
    
}

#pragma mark - RSKImageCropViewControllerDelegate

- (void)imageCropViewControllerDidCancelCrop:(RSKImageCropViewController *)controller
{
    [controller dismissViewControllerAnimated:YES completion:nil];
}

- (void)imageCropViewController:(RSKImageCropViewController *)controller didCropImage:(UIImage *)croppedImage usingCropRect:(CGRect)cropRect
{
    [controller dismissViewControllerAnimated:YES completion:^{
        [self sendRequestOfUploadHeaderImage:croppedImage];
    }];
}


#pragma mark requests
- (void)sendRequestOfUploadHeaderImage:(UIImage*)image
{
    
    [self showKVNProgress];
    NSData *imageData = UIImageJPEGRepresentation(image, 1);
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/html",@"text/plain",  nil];
    // 参数
    NSMutableDictionary *parameter = [NSMutableDictionary dictionary];
    [parameter setObject:User_Token forKey:@"token"];
    // 访问路径
    NSString *stringURL = [NSString stringWithFormat:@"%@%@%@",URI_BASE_SERVER,URI_ROOT,URI_HeadImgUpload];
    
    [manager POST:stringURL parameters:parameter constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        // 设置时间格式
        formatter.dateFormat = @"yyyyMMddHHmmss";
        NSString *str = [formatter stringFromDate:[NSDate date]];
        NSString *fileName = [NSString stringWithFormat:@"%@.png", str];
        [formData appendPartWithFileData:imageData name:@"head_img" fileName:fileName mimeType:@"image/png"];
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
        NSDictionary *result = responseObject;
        if ([result[@"status"] intValue] == 200) {
            [self sendRequestOfuserInfo];
        }else{
            [self hideKVNProgress];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [self hideKVNProgress];
    }];
}

- (void)sendRequestOfuserInfo
{
    NSMutableDictionary *paramToken = [NSMutableDictionary dictionary];
    [paramToken setObject:User_Token forKey:@"token"];
    [AFRequestManager SafeGET:URI_GetInfo parameters:paramToken success:^(NSURLSessionDataTask *task, id responseObject) {
        if ([((NSDictionary*)responseObject)[@"status"] intValue] == 200) {
            NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:((NSDictionary*)responseObject)[@"data"]];
            [dict setObject:User_Token forKey:@"token"];
            [dict setObject:CurrentUserToken forKey:@"currentToken"];
            UserModel *userModel = [[UserModel alloc]initWithDictionary:dict error:nil];
            [AccountHelper saveUserInfo:userModel];
            [wImageV setImageWithUrlString:userModel.headportrait placeholderImage:[UIImage imageNamed:@"150a.png"]];
        }
        [self hideKVNProgress];
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [MPNotificationView notifyWithText:@""
                                    detail:@"刷新头像失败,请重新进入尝试刷新!"
                             andTouchBlock:^(MPNotificationView *notificationView) {
                                 NSLog( @"Received touch for notification with text: %@", notificationView.textLabel.text );
                             }];
        [self hideKVNProgress];
    }];
    
}

/*新增*/
- (HXProvincialCitiesCountiesPickerview *)regionPickerView {
    if (!_regionPickerView) {
        _regionPickerView = [[HXProvincialCitiesCountiesPickerview alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
        
        __weak typeof(self) wself = self;
        _regionPickerView.completion = ^(NSString *provinceName,NSString *cityName) {
            [wself mudiyModifyHomeTownInfoWithprovinceName:provinceName cityName:cityName];
        };
        [self.navigationController.view addSubview:_regionPickerView];
    }
    return _regionPickerView;
}

- (void)mudiyModifyHomeTownInfoWithprovinceName:(NSString *)provinceName cityName:(NSString *)cityName
{
    NSMutableDictionary *paramToken = [NSMutableDictionary dictionary];
    [paramToken setObject:User_Token forKey:@"token"];
    NSString *infoStr = [NSString stringWithFormat:@"%@ %@",provinceName,cityName];
    [paramToken setObject:infoStr forKey:@"info"];
    [AFRequestManager SafePOST:URI_UserHometown parameters:paramToken success:^(NSURLSessionDataTask *task, id responseObject) {
        if ([((NSDictionary*)responseObject)[@"status"] intValue] == 200) {
            _userModel.hometown = responseObject[@"data"][@"info"];
            [AccountHelper saveUserInfo:_userModel];
            [mTableView reloadData];
        }else{
            [self showMPNotificationViewWithErrorMessage:@"修改失败,请重新尝试"];
        }
        [self hideKVNProgress];
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [self showMPNotificationViewWithErrorMessage:@"网络请求失败"];
        [self hideKVNProgress];
    }];
}

//修改感情状态代理
- (void)woodPickViewDidSelectWithStr:(NSString *)selectStr
{
    if ([NSString isBlankString:_userModel.mood]) {
        if ([selectStr isEqualToString:@"保密"]) {
            [mTableView reloadData];
        }
    }else{
        if ([selectStr isEqualToString:_userModel.mood]) {
            [mTableView reloadData];
        }else{
            [self mudiyModifyMoodInfoWithprovinceName:selectStr];
        }
    }
}

- (void)mudiyModifyMoodInfoWithprovinceName:(NSString *)selectStr
{
    NSMutableDictionary *paramToken = [NSMutableDictionary dictionary];
    [paramToken setObject:User_Token forKey:@"token"];
    [paramToken setObject:selectStr forKey:@"info"];
    [AFRequestManager SafePOST:URI_UserWood parameters:paramToken success:^(NSURLSessionDataTask *task, id responseObject) {
        if ([((NSDictionary*)responseObject)[@"status"] intValue] == 200) {
            _userModel.mood = responseObject[@"data"][@"info"];
            [AccountHelper saveUserInfo:_userModel];
            [mTableView reloadData];
        }else{
            [self showMPNotificationViewWithErrorMessage:@"修改失败,请重新尝试"];
        }
        [self hideKVNProgress];
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [self showMPNotificationViewWithErrorMessage:@"网络请求失败"];
        [self hideKVNProgress];
    }];
}
//修改生日代理
-(void)DatePickViewDidSelectWithStr:(NSString *)selectStr
{
    if ([NSString isBlankString:selectStr]) {
        return;
    }else{
        [self mudiyModifyBirthInfo:selectStr];
    }
}
- (void)mudiyModifyBirthInfo:(NSString *)selectStr
{
    NSMutableDictionary *paramToken = [NSMutableDictionary dictionary];
    [paramToken setObject:User_Token forKey:@"token"];
    [paramToken setObject:selectStr forKey:@"info"];
    [AFRequestManager SafePOST:URI_UserBirthday parameters:paramToken success:^(NSURLSessionDataTask *task, id responseObject) {
        if ([((NSDictionary*)responseObject)[@"status"] intValue] == 200) {
            _userModel.birth = responseObject[@"data"][@"info"];
            [AccountHelper saveUserInfo:_userModel];
            [mTableView reloadData];
        }else{
            [self showMPNotificationViewWithErrorMessage:@"修改失败,请重新尝试"];
        }
        [self hideKVNProgress];
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [self showMPNotificationViewWithErrorMessage:@"网络请求失败"];
        [self hideKVNProgress];
    }];
}

-(void)ModifyProfessionDidChanged
{
    [mTableView reloadData];
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
