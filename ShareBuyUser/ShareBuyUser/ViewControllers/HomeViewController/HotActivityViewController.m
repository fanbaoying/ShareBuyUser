//
//  HotActivityViewController.m
//  ShareBuyUser
//
//  Created by soldier on 16/8/22.
//  Copyright © 2016年 ShareBuy. All rights reserved.
//

#import "HotActivityViewController.h"
#import "ActivityCollectionViewCell.h"
#import "BaseWebViewController.h"

@interface HotActivityViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>
{
    NSInteger currentPage;
}

@property (nonatomic, strong) UICollectionView *hotCollectionView;
@property (nonatomic, strong) NSMutableArray *activityArray;

@end

@implementation HotActivityViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setTitle:@"热门活动"];
    
    [self.view addSubview:self.hotCollectionView];
    
    NSLog(@"获得更多热门活动信息");
    currentPage = 0;
    NSDictionary *dic = @{@"regionCode":[[NSUserDefaults standardUserDefaults] objectForKey:@"citycode"],@"pageIndex":[NSString stringWithFormat:@"%ld",currentPage+1]};
    [self getHotActivityRequestWithDict:dic];
}

#pragma mark - Get Method
- (UICollectionView *)hotCollectionView
{
    if (!_hotCollectionView) {
        _hotCollectionView = ({
            UICollectionViewFlowLayout *flowLayout= [[UICollectionViewFlowLayout alloc]init];
            [flowLayout setScrollDirection:UICollectionViewScrollDirectionVertical];
            
            UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight-kNavigationBarHight) collectionViewLayout:flowLayout];
            [collectionView setBackgroundColor:[UIColor clearColor]];
            [collectionView setDelegate:self];
            [collectionView setDataSource:self];
            [collectionView setAlwaysBounceVertical:YES];
            [collectionView setClipsToBounds:NO];
            [collectionView registerClass:[ActivityCollectionViewCell class] forCellWithReuseIdentifier:NSStringFromClass([ActivityCollectionViewCell class])];
            
            [collectionView addLegendFooterWithRefreshingBlock:^{
                currentPage++;
                NSLog(@"获得更多热门商户信息");
                NSDictionary *dic = @{@"regionCode":[[NSUserDefaults standardUserDefaults] objectForKey:@"citycode"],@"pageIndex":[NSString stringWithFormat:@"%ld",currentPage+1]};
                [self getHotActivityRequestWithDict:dic];
            }];
            
            collectionView;
        });
    }
    return _hotCollectionView;
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [_activityArray count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    ActivityCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([ActivityCollectionViewCell class]) forIndexPath:indexPath];
    [cell.activityImgView setImageWithURL:[NSURL URLWithString:_activityArray[indexPath.row][@"imgurl"]] placeholderImage:[UIImage imageNamed:@"product_placeholder"]];
    [cell.activityTitleLabel setText:_activityArray[indexPath.row][@"businessname"]];
    [cell.activitySubTitleLabel setText:_activityArray[indexPath.row][@"address"]];
    
    return cell;
}

#pragma mark - UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
    
    BaseWebViewController *baseWebVC = [[BaseWebViewController alloc] init];
    baseWebVC.title = _activityArray[indexPath.row][@"activityname"];
    baseWebVC.htmlString = _activityArray[indexPath.row][@"describes"];
    [self.navigationController pushViewController:baseWebVC animated:YES];
}

#pragma mark - UICollectionViewDelegateFlowLayout
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(kScreenWidth/2-12, kScreenWidth/2+35);
}


- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 8;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 8;
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(8, 8, 8, 8);
}

#pragma mark - NetWorking
//获得更多热门活动信息 
- (void)getHotActivityRequestWithDict:(NSDictionary *)dict
{
    [self showHudInView:self.view hint:nil];
    
    [DDPBLL requestWithURL:DEF_URL_GetActivityList  Dict:dict result:^(NSDictionary *responseDict) {
        [self hideHud];
        NSLog(@"%@",responseDict);
        if (responseDict == nil) {
            return ;
        }
        if ([[responseDict objectForKey:@"status"] integerValue] == 0) {
            if ([responseDict[@"data"] count] != 0) {
                self.activityArray = [NSMutableArray arrayWithArray:responseDict[@"data"]];
                [_hotCollectionView reloadData];
            }else
            {
                // legendFooter置为"没有更多内容了"状态
                [_hotCollectionView.legendFooter noticeNoMoreData];
            }
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
