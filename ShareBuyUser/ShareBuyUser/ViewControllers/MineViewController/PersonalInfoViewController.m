//
//  PersonalInfoViewController.m
//  ShareBuyUser
//
//  Created by soldier on 16/8/24.
//  Copyright © 2016年 ShareBuy. All rights reserved.
//

#import "PersonalInfoViewController.h"
#import "ModifyNickViewController.h"
#import <AVFoundation/AVFoundation.h>

@interface PersonalInfoViewController () <UITableViewDataSource,UITableViewDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>

@property (nonatomic, strong) UITableView *personalTableView;
@property (nonatomic, strong) UIImageView *headImgView;
@property (nonatomic, strong) UILabel *phoneLabel;
@property (nonatomic, strong) UILabel *nickNameLabel;

@property (nonatomic, strong) NSMutableArray *titleArray;

@end

@implementation PersonalInfoViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [_personalTableView reloadData];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"个人资料";
    
    self.titleArray = [NSMutableArray arrayWithArray:@[@"",@"手机",@"昵称"]];
    [self.view addSubview:self.personalTableView];
}

#pragma mark - Get Method
- (UITableView *)personalTableView
{
    if (!_personalTableView) {
        _personalTableView = ({
            UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight-kNavigationBarHight) style:UITableViewStylePlain];
            [tableView setDelegate:self];
            [tableView setDataSource:self];
            [tableView setBackgroundColor:[UIColor clearColor]];
            [tableView setTableHeaderView:[UIView new]];
            [tableView setTableFooterView:[UIView new]];
            [tableView setSeparatorInset:UIEdgeInsetsZero];
            [tableView setLayoutMargins:UIEdgeInsetsZero];
            
            tableView;
        });
    }
    return _personalTableView;
}

- (UIImageView *)headImgView
{
    if (!_headImgView) {
        _headImgView = ({
            UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 45, 45)];
            [imageView setImageWithURL:[NSURL URLWithString:[UserModel shareUserModel].userAvatar] placeholderImage:[UIImage imageNamed:@"mine_avatar_placeholder_image"]];
            imageView.layer.masksToBounds = YES;
            imageView.layer.cornerRadius = 22.5f;
            
            imageView;
        });
    }
    return _headImgView;
}

- (UILabel *)phoneLabel
{
    if (!_phoneLabel) {
        _phoneLabel = ({
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(kScreenWidth-160, 0, 150, 45)];
            [label setTextAlignment:NSTextAlignmentRight];
            [label setFont:UIFontPingFangMedium(14.0f)];
            
            label;
        });
    }
    return _phoneLabel;
}

- (UILabel *)nickNameLabel
{
    if (!_nickNameLabel) {
        _nickNameLabel = ({
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(kScreenWidth-160, 0, 150, 45)];
            [label setTextAlignment:NSTextAlignmentRight];
            [label setFont:UIFontPingFangMedium(14.0f)];
            
            label;
        });
    }
    return _nickNameLabel;
}


#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        return 65;
    }
    else
    {
        return 45;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSLog(@"选择cell");
    
    switch (indexPath.row) {
        case 0:
            NSLog(@"上传图片");
            [self modifyHeadImg];
            break;
        case 1:
            NSLog(@"绑定手机");
            if ([[UserModel shareUserModel].userPhone length] == 0) {
                NSLog(@"跳转至 绑定手机页面");
            }
            break;
        case 2:
            NSLog(@"修改昵称");
            NSLog(@"跳转至 修改昵称页面");
            [self.navigationController pushViewController:[ModifyNickViewController new] animated:YES];
            break;
            
        default:
            break;
    }
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_titleArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if(cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        [cell setSeparatorInset:UIEdgeInsetsZero];
        [cell setLayoutMargins:UIEdgeInsetsZero];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    switch (indexPath.row) {
        case 0:
        {
            [cell addSubview:self.headImgView];
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }
            break;
        case 1:
        {
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 100, 45)];
            [label setFont:UIFontPingFangMedium(14.0f)];
            [label setText:_titleArray[indexPath.row]];
            [cell addSubview:label];
            
            [cell addSubview:self.phoneLabel];
            if ([[UserModel shareUserModel].userPhone length] == 0) {
                [_phoneLabel setText:@"绑定"];
                [_phoneLabel setTextColor:kMainColor];
            }else
            {
                [_phoneLabel setText:[UserModel shareUserModel].userPhone];
                [_phoneLabel setTextColor:UIColorFromHex(0x696969, 1)];
            }
        }
            break;
        case 2:
        {
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 100, 45)];
            [label setFont:UIFontPingFangMedium(14.0f)];
            [label setText:_titleArray[indexPath.row]];
            [cell addSubview:label];
            
            [cell addSubview:self.nickNameLabel];
//            if ([[UserModel shareUserModel].userNick length] == 0) {
//                [_nickNameLabel setText:@"绑定"];
//                [_nickNameLabel setTextColor:kMainColor];
//            }else
//            {
                [_nickNameLabel setText:[UserModel shareUserModel].userNick];
                [_nickNameLabel setTextColor:UIColorFromHex(0x696969, 1)];
//            }
        }
            break;
            
        default:
            break;
    }
    
    
    return cell;
}

- (void)modifyHeadImg
{
    UIImagePickerController *imagePickerController = [UIImagePickerController new];
    imagePickerController.edgesForExtendedLayout = UIRectEdgeNone;
    imagePickerController.navigationBar.translucent = NO;
    imagePickerController.navigationBar.backgroundColor = kMainColor;
    imagePickerController.allowsEditing = YES;
    [imagePickerController setDelegate:self];
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"修改头像" message:@"" preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    UIAlertAction *archiveAction = [UIAlertAction actionWithTitle:@"相机" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        NSLog(@"相机拍照");
        NSString *mediaType = AVMediaTypeVideo;//读取媒体类型
        AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:mediaType];//读取设备授权状态
        if(authStatus == AVAuthorizationStatusRestricted || authStatus == AVAuthorizationStatusDenied){
            NSString *errorStr = @"请进入系统【设置】》【隐私】》【相机】中打开开关，并允许“分享购”访问您的相机";
            UIAlertController *alertCon = [UIAlertController alertControllerWithTitle:@"提示" message:errorStr preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *sureAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                [alertController dismissViewControllerAnimated:YES completion:nil];
            }];
            [alertCon addAction:sureAction];
            [self presentViewController:alertCon animated:YES completion:nil];

            return;
        }
        imagePickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
        [self presentViewController:imagePickerController animated:YES completion:NULL];
    }];
    UIAlertAction *albumAction = [UIAlertAction actionWithTitle:@"从相册选择" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        NSLog(@"相册选择");
        imagePickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        [self presentViewController:imagePickerController animated:YES completion:NULL];

    }];
    [alertController addAction:cancelAction];
    [alertController addAction:archiveAction];
    [alertController addAction:albumAction];
    
    [self presentViewController:alertController animated:YES completion:nil];
}

#pragma mark - UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
    [picker dismissViewControllerAnimated:YES completion:NULL];
    UIImage *originalImage = [info objectForKey:UIImagePickerControllerEditedImage];
    UIImage *noteImage = [self scaleWithImage:originalImage toSize:CGSizeMake(originalImage.size.width/5.0, originalImage.size.height/5.0)];
    //    NSData *data = UIImageJPEGRepresentation(noteImage, 0.4);
    NSDictionary *dic = @{@"headfile":@""};
    
    [self showHudInView:self.view hint:nil];
    [DDPBLL requestWithURL:DEF_URL_Upload Dict:dic andImage:noteImage andBlock:^(NSDictionary *responseDict) {
        [self hideHud];
        if (responseDict == nil) {
            return;
        }
        if ([responseDict[@"status"] integerValue] == 0) {
            NSLog(@"上传文件成功");
            NSDictionary *dic = @{@"token":[UserModel shareUserModel].userToken,@"headurl":responseDict[@"data"][0][@"headurl"]};
            [self uploadHeadRequestWithDict:dic WithSiteUrl:responseDict[@"data"][0][@"siteurl"]];
        }else
        {
            NSLog(@"上传文件失败");
        }
    }];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
    [picker dismissViewControllerAnimated:YES completion:NULL];
}

//图片压缩
- (UIImage *)scaleWithImage:(UIImage *)image toSize:(CGSize)size
{
    UIGraphicsBeginImageContext(size);
    [image drawInRect:CGRectMake(0, 0, size.width, size.height)];
    UIImage *scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return scaledImage;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Networking
//上传头像
- (void)uploadHeadRequestWithDict:(NSDictionary *)dict WithSiteUrl:(NSString *)siteurl
{
    [self showHudInView:self.view hint:nil];
    [DDPBLL requestWithURL:DEF_URL_UploadHead  Dict:dict result:^(NSDictionary *responseDict) {
        [self hideHud];
        NSLog(@"%@",responseDict);
        if (responseDict == nil) {
            return ;
        }
        if ([[responseDict objectForKey:@"status"] integerValue] == 0) {
            NSLog(@"修改头像成功");
            [[UserModel shareUserModel] setUserAvatar:[NSString stringWithFormat:@"%@%@",siteurl,dict[@"headurl"]]];
            [self.headImgView setImageWithURL:[NSURL URLWithString:[UserModel shareUserModel].userAvatar] placeholderImage:[UIImage imageNamed:@"mine_avatar_placeholder_image"]];
        }
        else{
            [self showHint:responseDict[@"msg"]];
        }
    }];
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
