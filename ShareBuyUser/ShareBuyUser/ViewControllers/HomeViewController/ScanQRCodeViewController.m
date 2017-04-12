    //
//  ScanQRCodeViewController.m
//  ShareBuyUser
//
//  Created by soldier on 16/8/9.
//  Copyright © 2016年 ShareBuy. All rights reserved.
//

#import "ScanQRCodeViewController.h"
#import "ScanResultViewController.h"

@interface ScanQRCodeViewController ()

@end

@implementation ScanQRCodeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setTitle:@"扫描"];
    
    // Device
    _device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    
    // Input
    _input = [AVCaptureDeviceInput deviceInputWithDevice:self.device error:nil ];
    
    // Output
    _output = [[AVCaptureMetadataOutput alloc] init];
    
    [_output setMetadataObjectsDelegate:self queue:dispatch_get_main_queue()];
    CGFloat x = 112*kWR/(kScreenHeight-kNavigationBarHight);
    CGFloat y = ((kScreenWidth - 200*kWR)/2)/kScreenWidth;
    
    [_output setRectOfInterest:CGRectMake(y, x, 200*kWR, 200*kWR)];
    // Session
    
    _session = [[ AVCaptureSession alloc ] init];
    [_session setSessionPreset:AVCaptureSessionPresetHigh];
    if ([_session canAddInput:self.input])
    {
        [_session addInput:self.input];
    }
    
    if ([_session canAddOutput:self.output])
    {
        [_session addOutput:self.output];
    }
    
    // 条码类型 AVMetadataObjectTypeQRCode
    [_output setMetadataObjectTypes:[NSArray arrayWithObjects:AVMetadataObjectTypeQRCode,AVMetadataObjectTypeEAN13Code, AVMetadataObjectTypeEAN8Code, AVMetadataObjectTypeCode128Code, AVMetadataObjectTypeQRCode, nil]];
    
    // Preview
    _preview =[AVCaptureVideoPreviewLayer layerWithSession:_session];
    _preview.videoGravity = AVLayerVideoGravityResizeAspectFill;
    _preview.frame = self.view.layer.bounds ;
    //    [ self . view . layer insertSublayer : _preview atIndex : 0 ];
    [self.view.layer addSublayer:_preview];
    
    [self.view addSubview:self.scanQrCodeView];
    
    UILabel *remindLabel = [[UILabel alloc] initWithFrame:CGRectMake(kScreenWidth/2 - 200*kWR/2, (112 - 50)*kWR, 200*kWR, 20)];
    remindLabel.backgroundColor = [UIColor clearColor];
    remindLabel.text = @"将二维码放入到扫描框内";
    remindLabel.font = [UIFont systemFontOfSize:15];
    remindLabel.textColor = [UIColor whiteColor];
    remindLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:remindLabel];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    // Start
    [_session startRunning];
}

- (ScanQrCodeView *)scanQrCodeView
{
    if (!_scanQrCodeView) {
        _scanQrCodeView = ({
            ScanQrCodeView *view = [[ScanQrCodeView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight - kNavigationBarHight)];
            [view setBackgroundColor:[UIColor clearColor]];
            
            view;
        });
    }
    return _scanQrCodeView;
}

#pragma mark AVCaptureMetadataOutputObjectsDelegate
- (void)captureOutput:( AVCaptureOutput *)captureOutput didOutputMetadataObjects:( NSArray *)metadataObjects fromConnection:( AVCaptureConnection *)connection

{
    NSString *stringValue;
    if ([metadataObjects count ] > 0 )
    {
        // 停止扫描
        [_session stopRunning];
        
        AVMetadataMachineReadableCodeObject * metadataObject = [metadataObjects objectAtIndex:0 ];
        stringValue = metadataObject. stringValue;
        NSLog(@"扫描结果 ： %@",stringValue);
        
        NSRange range;
        range = [stringValue rangeOfString:@"="];
        if (range.location != NSNotFound) {
            NSLog(@"found at location = %lu, length = %lu",(unsigned long)range.location,(unsigned long)range.length);
        }else{
            NSLog(@"Not Found");
        }
        stringValue = [stringValue substringFromIndex:range.location+1];
        
        NSDictionary *dic = @{@"oid":stringValue};
        [self getOrderDetailByScanRequestWithDict:dic];
    }
}

#pragma mark - NetWorking 
- (void)getOrderDetailByScanRequestWithDict:(NSDictionary *)dict
{
    [self showHudInView:self.view hint:nil];
    [DDPBLL requestWithURL:DEF_URL_GetOrderDetailByScan  Dict:dict result:^(NSDictionary *responseDict) {
        [self hideHud];
        NSLog(@"%@",responseDict);
        if (responseDict == nil) {
            return ;
        }
        if ([[responseDict objectForKey:@"status"] integerValue] == 0) {
            ScanResultViewController *scanResultVC = [[ScanResultViewController alloc] init];
            scanResultVC.orderInfoDic = responseDict[@"data"];
            [self.navigationController pushViewController:scanResultVC animated:YES];
        }
        else{
            [self showHint:responseDict[@"msg"]];
        }
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
