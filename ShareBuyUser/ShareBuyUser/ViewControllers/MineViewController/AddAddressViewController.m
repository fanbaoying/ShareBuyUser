//
//  AddAddressViewController.m
//  ShareBuyUser
//
//  Created by Marx on 16/8/19.
//  Copyright © 2016年 ShareBuy. All rights reserved.
//

#import "AddAddressViewController.h"

@interface AddAddressViewController ()<UITextFieldDelegate,UITextViewDelegate,UIPickerViewDataSource,UIPickerViewDelegate>

@property(nonatomic)UITextField *nameTextField;
@property(nonatomic)UITextField *phoneTextField;
@property(nonatomic)UITextField *addressTextField;

@property(nonatomic)UIView *selectAddressView;
@property(nonatomic)UIPickerView *addressPickerView;
@property(nonatomic)NSArray *addressArray;

@property(nonatomic)UITextView *addressTextView;
@property(nonatomic)UIButton *defaultButton;

@property(nonatomic)NSMutableDictionary *addressDic;

@property(nonatomic)UIButton *submitButton;

@end

@implementation AddAddressViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initData];
    [self customView];
}
#pragma mark InitData
- (void)initData
{
    NSString *path = [[NSBundle mainBundle] pathForResource:@"AreaList.plist" ofType:nil];
    NSDictionary *dic = [NSDictionary dictionaryWithContentsOfFile:path];
    _addressArray = dic[@"root"];
    
    _addressDic = [[NSMutableDictionary alloc] initWithDictionary:@{@"provinceid":@"",@"provincename":@"",@"cityid":@"",@"cityname":@"",@"countryid":@"",@"countryname":@""}];
}

#pragma mark Custom View
- (void)customView
{
    UIView *bgView = ({
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 5, kScreenWidth, 270)];
        [view setBackgroundColor:[UIColor whiteColor]];
        UILabel *nameLabel = ({
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(15, 15, 80, 35)];
            [label setBackgroundColor:[UIColor clearColor]];
            [label setTextColor:UIColorFromHex(0x696969, 1)];
            [label setFont:UIFontPingFangRegular(15)];
            [label setText:@"收货人："];
            label;
        });
        [view addSubview:nameLabel];
        [view addSubview:self.nameTextField];
        UILabel *phoneLabel = ({
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(15, 65, 80, 35)];
            [label setBackgroundColor:[UIColor clearColor]];
            [label setTextColor:UIColorFromHex(0x696969, 1)];
            [label setFont:UIFontPingFangRegular(15)];
            [label setText:@"联系电话："];
            label;
        });
        [view addSubview:phoneLabel];
        [view addSubview:self.phoneTextField];
        
        UILabel *addressLabel = ({
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(15, 115, 100, 35)];
            [label setBackgroundColor:[UIColor clearColor]];
            [label setTextColor:UIColorFromHex(0x696969, 1)];
            [label setFont:UIFontPingFangRegular(15)];
            [label setText:@"所在省市区/县"];
            label;
        });
        [view addSubview:addressLabel];
        [view addSubview:self.addressTextField];
        
        [view addSubview:self.addressTextView];
        view;
    });
    
    [self.view addSubview:bgView];
    [self.view addSubview:self.submitButton];
    [self.view addSubview:self.defaultButton];
    
    UILabel *defaultLabel = ({
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(40, 280, kScreenWidth - 50, 30)];
        [label setBackgroundColor:[UIColor clearColor]];
        [label setTextColor:UIColorFromHex(0x696969, 1)];
        [label setFont:UIFontPingFangRegular(15)];
        [label setText:@"设为默认地址"];
        label;
    });
    [self.view addSubview:defaultLabel];
    [self.view addSubview:self.selectAddressView];
    
    
}

- (UITextField *)nameTextField
{
    if (!_nameTextField) {
        _nameTextField = ({
            UITextField *textField = [[UITextField alloc] initWithFrame:CGRectMake(100, 15, kScreenWidth - 115, 35)];
            [textField setDelegate:self];
            [textField setTag:100];
            [textField setBorderStyle:UITextBorderStyleRoundedRect];
            [textField setAutocorrectionType:UITextAutocorrectionTypeNo];
            [textField setAutocapitalizationType:UITextAutocapitalizationTypeNone];
            [textField setReturnKeyType:UIReturnKeyDone];
            [textField setPlaceholder:@"请输入收货人姓名"];
            [textField setText:_addressDict[@"name"]];
            [textField setTextColor:UIColorFromHex(0x999999, 1)];
            [textField setFont:UIFontPingFangRegular(15)];
            textField;
        });
    }
    return _nameTextField;
}

- (UITextField *)phoneTextField
{
    if (!_phoneTextField) {
        _phoneTextField = ({
            UITextField *textField = [[UITextField alloc] initWithFrame:CGRectMake(100, 65, kScreenWidth - 115, 35)];
            [textField setDelegate:self];
            [textField setTag:101];
            [textField setBorderStyle:UITextBorderStyleRoundedRect];
            [textField setAutocorrectionType:UITextAutocorrectionTypeNo];
            [textField setAutocapitalizationType:UITextAutocapitalizationTypeNone];
            [textField setReturnKeyType:UIReturnKeyDone];
            [textField setPlaceholder:@"请输入联系电话"];
            [textField setKeyboardType:UIKeyboardTypePhonePad];
            [textField setText:_addressDict[@"phone"]];
            [textField setTextColor:UIColorFromHex(0x999999, 1)];
            [textField setFont:UIFontPingFangRegular(15)];
            textField;
        });
    }
    return _phoneTextField;
}

- (UITextField *)addressTextField
{
    if (!_addressTextField) {
        _addressTextField = ({
            UITextField *textField = [[UITextField alloc] initWithFrame:CGRectMake(120, 115, kScreenWidth - 135, 35)];
            [textField setDelegate:self];
            [textField setTag:102];
            [textField setAutocorrectionType:UITextAutocorrectionTypeNo];
            [textField setAutocapitalizationType:UITextAutocapitalizationTypeNone];
            [textField setReturnKeyType:UIReturnKeyDone];
            [textField setTextAlignment:NSTextAlignmentRight];
            [textField setPlaceholder:@"请选择"];
            if ([_addressDict[@"provincename"] length] > 0&&[_addressDict[@"cityname"] length] > 0&&[_addressDict[@"countryname"] length] > 0) {
                [textField setText:[NSString stringWithFormat:@"%@%@%@",_addressDict[@"provincename"],_addressDict[@"cityname"],_addressDict[@"countryname"]]];
            }
            [textField setValue:kMainColor forKeyPath:@"_placeholderLabel.textColor"];
            [textField setTextColor:UIColorFromHex(0x999999, 1)];
            [textField setFont:UIFontPingFangRegular(15)];
            textField;
        });
    }
    return _addressTextField;
}

- (UITextView *)addressTextView
{
    if (!_addressTextView) {
        _addressTextView = ({
            UITextView *textView = [[UITextView alloc] initWithFrame:CGRectMake(15, 165, kScreenWidth -30, 90)];
            [textView setDelegate:self];
            [textView.layer setMasksToBounds:YES];
            [textView.layer setCornerRadius:5];
            [textView setBackgroundColor:UIColorFromHex(0xf6f6f6, 1)];
            [textView setTextColor:UIColorFromHex(0xbbbbbb, 1)];
            [textView setFont:UIFontPingFangRegular(15)];
            [textView setAutocorrectionType:UITextAutocorrectionTypeNo];
            [textView setAutocapitalizationType:UITextAutocapitalizationTypeNone];
            [textView setReturnKeyType:UIReturnKeyDone];
            if (_addressDict == nil) {
                [textView setText:@"请输入详细地址"];
            }else
            {
                [textView setText:_addressDict[@"address"]];
            }
            
            textView;
        });
    }
    return _addressTextView;
}

- (UIButton *)defaultButton
{
    if (!_defaultButton) {
        _defaultButton = ({
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            [button setFrame:CGRectMake(10, 280, 30, 30)];
            [button setImage:[UIImage imageNamed:@"check_normal"] forState:UIControlStateNormal];
            [button setImage:[UIImage imageNamed:@"check_select"] forState:UIControlStateSelected];
            [button addTarget:self action:@selector(selectDefaultButton:) forControlEvents:UIControlEventTouchUpInside];
            [button setSelected:[_addressDict[@"isdefault"] integerValue]];
            
            button;
        });
    }
    return _defaultButton;
}

- (UIButton *)submitButton
{
    if (!_submitButton) {
        _submitButton = ({
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            [button setFrame:CGRectMake(15, kScreenHeight - kNavigationBarHight-45, kScreenWidth -30, 35)];
            [button setBackgroundImage:[UIImage imageWithColor:kMainColor size:CGSizeMake(1, 1)] forState:UIControlStateNormal];
            [button.layer setMasksToBounds:YES];
            [button.layer setCornerRadius:5];
            [button setTitle:@"提交" forState:UIControlStateNormal];
            [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [button.titleLabel setFont:UIFontPingFangRegular(15)];
            [button addTarget:self action:@selector(selectSubmitButton:) forControlEvents:UIControlEventTouchUpInside];
            button;
        });
    }
    return _submitButton;
}

- (UIView *)selectAddressView
{
    if (!_selectAddressView) {
        _selectAddressView = ({
            UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, kScreenHeight -kNavigationBarHight, kScreenWidth, 200)];
            [view setBackgroundColor:[UIColor whiteColor]];
            
            UIButton *cancelButton = ({
                UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
                [button setFrame:CGRectMake(0, 0, 60, 40)];
                [button setTitle:@"取消" forState:UIControlStateNormal];
                [button setTitleColor:UIColorFromHex(0x999999, 1) forState:UIControlStateNormal];
                [button.titleLabel setFont:UIFontPingFangRegular(15)];
                [button addTarget:self action:@selector(selectCancelButton:) forControlEvents:UIControlEventTouchUpInside];
                button;
            });
            [view addSubview:cancelButton];
            
            UIButton *doneButton = ({
                UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
                [button setFrame:CGRectMake(kScreenWidth -60, 0, 60, 40)];
                [button setTitle:@"完成" forState:UIControlStateNormal];
                [button setTitleColor:kMainColor forState:UIControlStateNormal];
                [button.titleLabel setFont:UIFontPingFangRegular(15)];
                [button addTarget:self action:@selector(selectDoneButton:) forControlEvents:UIControlEventTouchUpInside];
                button;
            });
            [view addSubview:doneButton];
            
            UIView *lineView = ({
                UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 39.75, kScreenWidth, 0.5)];
                [view setBackgroundColor:UIColorFromHex(0xbbbbbb, 1)];
                view;
            });
            [view addSubview:lineView];
            [view addSubview:self.addressPickerView];
            
            view;
        });
    }
    return _selectAddressView;
}

- (UIPickerView *)addressPickerView
{
    if (!_addressPickerView) {
        _addressPickerView = ({
            UIPickerView *pickerView = [[UIPickerView alloc] initWithFrame:CGRectMake(0, 40, kScreenWidth, 160)];
            [pickerView setDelegate:self];
            [pickerView setDataSource:self];
            [pickerView setBackgroundColor:[UIColor clearColor]];
            
            pickerView;
        });
    }
    return _addressPickerView;
}


#pragma mark UITextFieldDelegate
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    if (textField.tag == 102) {
        [UIView animateWithDuration:0.3 animations:^{
            [_selectAddressView setFrame:CGRectMake(0, kScreenHeight - kNavigationBarHight -200, kScreenWidth, 200)];
        }];
        return NO;
    }else{
        [_nameTextField resignFirstResponder];
        [_phoneTextField resignFirstResponder];
        [_addressTextView resignFirstResponder];
        [self dismissSelectAddressView];
        return YES;
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}
#pragma mark UITextViewDelegate
- (void)textViewDidBeginEditing:(UITextView *)textView
{
    [self dismissSelectAddressView];
    if ([textView.text isEqualToString:@"请输入详细地址"]) {
        [textView setText:@""];
        [textView setTextColor:UIColorFromHex(0x999999, 1)];
    }
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if ([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
        return NO;
    }
    return YES;
}

- (void)textViewDidEndEditing:(UITextView *)textView
{
    if (textView.text.length <=0) {
        [textView setText:@"请输入详细地址"];
        [textView setTextColor:UIColorFromHex(0xbbbbbb, 1)];
    }
}

#pragma mark UIPickerViewDataSource
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 3;
}

- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component
{
    return kScreenWidth/3;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    switch (component) {
        case 0:
            return [_addressArray count];
            break;
        case 1:
        {
            return [_addressArray[[pickerView selectedRowInComponent:0]][@"region_child"] count];
        }
            break;
        case 2:
        {
            return [_addressArray[[pickerView selectedRowInComponent:0]][@"region_child"][[pickerView selectedRowInComponent:1]][@"region_child"] count];
        }
            break;
        
        default:
            return 0;
            break;
    }
}

- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component
{
    return 30;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    switch (component) {
        case 0:
            return _addressArray[row][@"region_name"];
            break;
        case 1:
            return _addressArray[[pickerView selectedRowInComponent:0]][@"region_child"][row][@"region_name"];
            break;
        case 2:
            return _addressArray[[pickerView selectedRowInComponent:0]][@"region_child"][[pickerView selectedRowInComponent:1]][@"region_child"][row][@"region_name"];
            break;
        default:
            return @"";
            break;
    }
}

#pragma mark UIPickerViewDelegate
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    switch (component) {
        case 0:
            [pickerView selectRow:0 inComponent:1 animated:NO];
            [pickerView reloadComponent:1];
            [pickerView selectRow:0 inComponent:2 animated:NO];
            [pickerView reloadComponent:2];
            
            break;
        case 1:
            [pickerView selectRow:0 inComponent:2 animated:NO];
            [pickerView reloadComponent:2];
            
            
            break;
        case 2:
            
            break;
        default:
            break;
    }
}


#pragma mark Button Action
- (IBAction)selectCancelButton:(id)sender
{
    [self dismissSelectAddressView];
}

- (IBAction)selectDoneButton:(id)sender
{
    [self dismissSelectAddressView];
    NSDictionary *pDic = _addressArray[[_addressPickerView selectedRowInComponent:0]];
    NSDictionary *cDic = pDic[@"region_child"][[_addressPickerView selectedRowInComponent:1]];
    NSDictionary *aDic = cDic[@"region_child"][[_addressPickerView selectedRowInComponent:2]];
    
    [_addressDic setObject:[NSString stringWithFormat:@"%@",pDic[@"region_id"]] forKey:@"provinceid"];
    [_addressDic setObject:pDic[@"region_name"] forKey:@"provincename"];
    [_addressDic setObject:[NSString stringWithFormat:@"%@",cDic[@"region_id"]] forKey:@"cityid"];
    [_addressDic setObject:cDic[@"region_name"] forKey:@"cityname"];
    [_addressDic setObject:[NSString stringWithFormat:@"%@",aDic[@"region_id"]] forKey:@"countryid"];
    [_addressDic setObject:aDic[@"region_name"] forKey:@"countryname"];
    NSLog(@"%@",_addressDic);
    
    [_addressTextField setTextColor:UIColorFromHex(0x999999, 1)];
    [_addressTextField setText:[NSString stringWithFormat:@"%@%@%@",_addressDic[@"provincename"],_addressDic[@"cityname"],_addressDic[@"countryname"]]];
}

- (void)dismissSelectAddressView
{
    [UIView animateWithDuration:0.3 animations:^{
        [_selectAddressView setFrame:CGRectMake(0, kScreenHeight - kNavigationBarHight, kScreenWidth, 200)];
    }];
}

- (IBAction)selectDefaultButton:(UIButton *)sender
{
    [self dismissSelectAddressView];
    [sender setSelected:!sender.selected];
}

- (IBAction)selectSubmitButton:(id)sender
{
    if (_addressDict == nil) {
        [self requestAddAddressData];
    }else
    {
        [self editUserAddressRequest];
    }
}

- (void)requestAddAddressData
{
    [self dismissSelectAddressView];
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:@"" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    [alertController addAction:cancelAction];
    
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    if ([_addressDic[@"provinceid"] length]>0&&[_addressDic[@"cityid"] length]>0&&[_addressDic[@"countryid"] length]>0) {
        [dic setDictionary:_addressDic];
    }else{
        [alertController setMessage:@"请选择所属省市区/县"];
        [self presentViewController:alertController animated:YES completion:^{
            
        }];
        return;
    }
    
    if (_nameTextField.text.length>0) {
        [dic setObject:_nameTextField.text forKey:@"name"];
    }else{
        [alertController setMessage:@"请输入收货人姓名"];
        [self presentViewController:alertController animated:YES completion:^{
            
        }];
        return;
    }
    
    if (_phoneTextField.text.length!=0) {
        [dic setObject:_phoneTextField.text forKey:@"phone"];
        
    }else{
        [alertController setMessage:@"请输入正确联系电话"];
        [self presentViewController:alertController animated:YES completion:^{
            
        }];
        return;
    }
    
    if (![_addressTextView.text isEqualToString:@"请输入详细地址"]) {
        [dic setObject:_addressTextView.text forKey:@"address"];
    }else{
        [alertController setMessage:@"请输入详细地址"];
        [self presentViewController:alertController animated:YES completion:^{
            
        }];
        return;
    }
    
    if (_defaultButton.selected) {
        [dic setObject:@"1" forKey:@"isdefault"];
    }else{
        [dic setObject:@"0" forKey:@"isdefault"];
    }
    [dic setObject:@"0" forKey:@"isdel"];
    
    [dic setObject:[UserModel shareUserModel].userToken forKey:@"token"];
    NSLog(@"%@",dic);
    
    [self showHudInView:self.view hint:nil];
    [DDPBLL requestWithURL:DEF_URL_AddAddress  Dict:dic result:^(NSDictionary *responseDict) {
        [self hideHud];
        NSLog(@"%@",responseDict);
        if (responseDict == nil) {
            //            [self showHint:@"处理失败，请稍后再试"];
            return ;
        }
        if ([[responseDict objectForKey:@"status"] integerValue]==0) {
            [self.navigationController popViewControllerAnimated:YES];
        }else{
            [self showHint:responseDict[@"msg"]];
        }
    }];
}

//地址修改
- (void)editUserAddressRequest
{
    [self dismissSelectAddressView];
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:@"" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    [alertController addAction:cancelAction];
    
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    if ([_addressDic[@"provinceid"] length]>0&&[_addressDic[@"cityid"] length]>0&&[_addressDic[@"countryid"] length]>0) {
        [dic setDictionary:_addressDic];
    }else{
        if (_addressDict != nil) {
            [dic setValue:_addressDict[@"cityid"] forKey:@"cityid"];
            [dic setValue:_addressDict[@"cityname"] forKey:@"cityname"];
            [dic setValue:_addressDict[@"countryid"] forKey:@"countryid"];
            [dic setValue:_addressDict[@"countryname"] forKey:@"countryname"];
            [dic setValue:_addressDict[@"provinceid"] forKey:@"provinceid"];
            [dic setValue:_addressDict[@"provincename"] forKey:@"provincename"];
        }else
        {
            [alertController setMessage:@"请选择所属省市区/县"];
            [self presentViewController:alertController animated:YES completion:^{
                
            }];
            return;
        }
    }
    
    if (_nameTextField.text.length>0) {
        [dic setObject:_nameTextField.text forKey:@"name"];
    }else{
        [alertController setMessage:@"请输入收货人姓名"];
        [self presentViewController:alertController animated:YES completion:^{
            
        }];
        return;
    }
    
    if (_phoneTextField.text.length!=0) {
        [dic setObject:_phoneTextField.text forKey:@"phone"];
        
    }else{
        [alertController setMessage:@"请输入正确联系电话"];
        [self presentViewController:alertController animated:YES completion:^{
            
        }];
        return;
    }
    
    if (![_addressTextView.text isEqualToString:@"请输入详细地址"]) {
        [dic setObject:_addressTextView.text forKey:@"address"];
    }else{
        [alertController setMessage:@"请输入详细地址"];
        [self presentViewController:alertController animated:YES completion:^{
            
        }];
        return;
    }
    
    if (_defaultButton.selected) {
        [dic setObject:@"1" forKey:@"isdefault"];
    }else{
        [dic setObject:@"0" forKey:@"isdefault"];
    }
    [dic setObject:@"0" forKey:@"isdel"];
    
    [dic setObject:[UserModel shareUserModel].userToken forKey:@"token"];
    [dic setValue:_addressDict[@"useraddressid"] forKey:@"useraddressid"];
    NSLog(@"%@",dic);
    
    [self showHudInView:self.view hint:nil];
    [DDPBLL requestWithURL:DEF_URL_EditAddress  Dict:dic result:^(NSDictionary *responseDict) {
        [self hideHud];
        NSLog(@"%@",responseDict);
        if (responseDict == nil) {
            //            [self showHint:@"处理失败，请稍后再试"];
            return ;
        }
        if ([[responseDict objectForKey:@"status"] integerValue]==0) {
            [self.navigationController popViewControllerAnimated:YES];
        }else{
            [self showHint:responseDict[@"msg"]];
        }
    }];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [_nameTextField resignFirstResponder];
    [_phoneTextField resignFirstResponder];
    [_addressTextField resignFirstResponder];
    [_addressTextView resignFirstResponder];
    
    [self dismissSelectAddressView];
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
