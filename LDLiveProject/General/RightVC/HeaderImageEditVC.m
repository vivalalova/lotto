//
//  HeaderImageEditVC.m
//  LDLiveProject
//
//  Created by MAC on 16/7/2.
//  Copyright © 2016年 MAC. All rights reserved.
//

#import "HeaderImageEditVC.h"
#import "UserModel.h"
#import "RSKImageCropViewController.h"
#import "AFHTTPSessionManager.h"

@interface HeaderImageEditVC ()<UIImagePickerControllerDelegate,UINavigationControllerDelegate, UIImagePickerControllerDelegate,RSKImageCropViewControllerDelegate>
{
    UserModel *_userModel;
}
@property (weak, nonatomic) IBOutlet WebImageView *headerImageView;
@property (weak, nonatomic) IBOutlet UIButton *paizhaoButton;
@property (weak, nonatomic) IBOutlet UIButton *xiangceButton;
@property (weak, nonatomic) IBOutlet UIButton *closeButton;

@end

@implementation HeaderImageEditVC

- (void)viewDidLoad {
    [super viewDidLoad];
    _userModel = [AccountHelper userInfo];
    [self UIInit];
    // Do any additional setup after loading the view from its nib.
}


- (void)UIInit
{
    [_headerImageView setImageWithURL:[NSURL URLWithString:_userModel.portrait] placeholderImage:[UIImage imageByApplyingAlpha:1 color:UIColorFromRGB(245, 245, 245)]];
    [_paizhaoButton setBackgroundColor:[UIColor colorWithHexString:@"0x2e3639"]];
    [_xiangceButton setBackgroundColor:[UIColor colorWithHexString:@"0x2e3639"]];
    [_closeButton setBackgroundColor:[UIColor colorWithHexString:@"0x2e3639"]];
    _paizhaoButton.layer.cornerRadius = _paizhaoButton.height/2;
    _paizhaoButton.clipsToBounds = YES;
    _xiangceButton.layer.cornerRadius = _xiangceButton.height/2;
    _xiangceButton.clipsToBounds = YES;
    _closeButton.layer.cornerRadius = 5;
    _closeButton.clipsToBounds = YES;
}


- (IBAction)paizhaoButtonClickAction:(id)sender {
    [self snapImage];
}

- (IBAction)xiangceButtonClickAction:(id)sender {
    [self pickImage];
}
- (IBAction)closeButtonClickAction:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
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
            [_headerImageView setImageWithURL:[NSURL URLWithString:userModel.portrait] placeholderImage:[UIImage imageByApplyingAlpha:1 color:UIColorFromRGB(245, 245, 245)]];
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
