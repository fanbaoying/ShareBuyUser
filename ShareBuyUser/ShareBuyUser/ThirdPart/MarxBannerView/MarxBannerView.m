//
//  MarxBannerView.m
//  CloudCampus
//
//  Created by Marx on 16/2/28.
//  Copyright © 2016年 Marx. All rights reserved.
//

#import "MarxBannerView.h"


@interface MarxBannerView() <UIScrollViewDelegate,MarxBannerViewPageDelegate>

@property(nonatomic,strong)UIScrollView *scrollView;

@property(nonatomic,assign)NSInteger pageNumber;
@property(nonatomic,assign)NSInteger currentPage;

@property(nonatomic)NSMutableArray *visiablePage;
@property(nonatomic)NSMutableArray *reusablePage;

@end

@implementation MarxBannerView



/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
    }
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    NSArray *subViews = self.subviews;
    [subViews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    [self initialize];
    
}

- (void)initialize
{
    [self setClipsToBounds:YES];
    self.visiablePage;
    self.reusablePage;
    [self setContinuity:YES];
    [self addSubview:self.scrollView];
    [self addSubview:self.pageControl];
    [self loadData];
    
}
- (NSMutableArray *)visiablePage
{
    if (!_visiablePage) {
        _visiablePage = ({
            NSMutableArray *array = [[NSMutableArray alloc] init];
            
            array;
        });
    }
    
    return _visiablePage;
}

- (NSMutableArray *)reusablePage
{
    if (!_reusablePage) {
        _reusablePage = ({
            NSMutableArray *array = [[NSMutableArray alloc] init];
            array;
        });
    }
    return _reusablePage;
}


- (UIScrollView *)scrollView
{
    if (!_scrollView) {
        _scrollView = ({
            UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.frame), CGRectGetHeight(self.frame))];
            
            [scrollView setDelegate:self];
            [scrollView setPagingEnabled:YES];
            [scrollView setShowsHorizontalScrollIndicator:NO];
            [scrollView setShowsVerticalScrollIndicator:NO];
            [scrollView setAutoresizingMask:self.autoresizingMask];
            [scrollView setScrollsToTop:NO];
            scrollView;
        });
    }
    
    return _scrollView;
}

- (UIPageControl *)pageControl
{
    if (!_pageControl) {
        _pageControl = ({
            UIPageControl *pageControl = [[UIPageControl alloc] init];
            [pageControl setUserInteractionEnabled:NO];
            [pageControl setHidesForSinglePage:YES];
            
            pageControl;
        });
    }
    if ([self.datasource respondsToSelector:@selector(frameForPageControlInMarxBannerView:)]) {
        [_pageControl setFrame:[self.datasource frameForPageControlInMarxBannerView:self]];
        [_pageControl setFrame:CGRectMake(0, CGRectGetHeight(self.frame)-30, CGRectGetWidth(self.frame), 30)];
    }else{
        
    }
    
    return _pageControl;
}

- (void)loadData
{
    _pageNumber = [self.datasource numberOfPageInBannerView:self];
    _currentPage = 0;
    if (_pageNumber==0) {
        return;
    }
    
    _pageControl.numberOfPages = _pageNumber;
    _pageControl.currentPage = 0;
    
    if (_pageNumber == 1) {
        [_scrollView setContentSize:self.frame.size];
        [_visiablePage addObject:[self.datasource marxBannerView:self pageForPage:0]];
    }else{
        [_scrollView setContentSize:CGSizeMake(CGRectGetWidth(self.frame)*3, CGRectGetHeight(self.frame))];
        if (self.isContinuity) {
            [_visiablePage addObject:[self.datasource marxBannerView:self pageForPage:_pageNumber-1]];
        }
        [_visiablePage addObject:[self.datasource marxBannerView:self pageForPage:_currentPage]];
        [_visiablePage addObject:[self.datasource marxBannerView:self pageForPage:_currentPage+1]];
    }
    for (int i = 0; i<[_visiablePage count]; i++) {
        MarxBannerViewPage *bannerViewPage = _visiablePage[i];
        [bannerViewPage setDelegate:self];
        [bannerViewPage setFrame:CGRectMake(CGRectGetWidth(self.frame)*i, 0, CGRectGetWidth(self.frame), CGRectGetHeight(self.frame))];
        [_scrollView addSubview:bannerViewPage];
    }
    if (self.isContinuity) {
        [_scrollView setContentOffset:CGPointMake(CGRectGetWidth(self.frame), 0)];
    }
}

#pragma mark UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    if (self.isContinuity) {
        CGFloat targetX = scrollView.contentOffset.x;
        NSInteger targetPage = targetX/CGRectGetWidth(self.frame)-1;
//        NSLog(@"%ld",(long)targetPage);
        _currentPage = targetPage+_currentPage;
        if (_currentPage == _pageNumber) {
            _currentPage = 0;
        }
        if (_currentPage == -1) {
            _currentPage = _pageNumber -1;
        }
//        NSLog(@"%ld",_currentPage);
        [_pageControl setCurrentPage:_currentPage];
        if (targetPage==0) {
            return;
        }
        else if(targetPage > 0)
        {
            [_reusablePage addObject:_visiablePage[0]];
            [[_visiablePage objectAtIndex:0] removeFromSuperview];
            [_visiablePage removeObjectAtIndex:0];
            
            for (int i=0; i<[_visiablePage count]; i++) {
                MarxBannerViewPage *bannerViewPage = _visiablePage[i];
                [bannerViewPage setFrame:CGRectMake(CGRectGetWidth(self.frame)*i, 0, CGRectGetWidth(self.frame), CGRectGetHeight(self.frame))];
            }
            [_scrollView setContentOffset:CGPointMake(CGRectGetWidth(self.frame), 0)];
            NSInteger nextPage;
            if (_currentPage==_pageNumber-1) {
                nextPage = 0;
            }else{
                nextPage = _currentPage+1;
            }
            MarxBannerViewPage *bannerViewPage = [self.datasource marxBannerView:self pageForPage:nextPage];
            [bannerViewPage setDelegate:self];
            [bannerViewPage setFrame:CGRectMake(CGRectGetWidth(self.frame)*2, 0, CGRectGetWidth(self.frame), CGRectGetHeight(self.frame))];
            [_scrollView addSubview:bannerViewPage];
            [_visiablePage addObject:bannerViewPage];
        }else if(targetPage < 0){
            [_reusablePage addObject:_visiablePage[2]];
            [[_visiablePage objectAtIndex:2] removeFromSuperview];
            [_visiablePage removeObjectAtIndex:2];
            
            for (int i=0; i<[_visiablePage count]; i++) {
                MarxBannerViewPage *bannerViewPage = _visiablePage[i];
                [bannerViewPage setFrame:CGRectMake(CGRectGetWidth(self.frame)*(i+1), 0, CGRectGetWidth(self.frame), CGRectGetHeight(self.frame))];
            }
            [_scrollView setContentOffset:CGPointMake(CGRectGetWidth(self.frame), 0)];
            NSInteger lastPage;
            if (_currentPage==0) {
                lastPage = _pageNumber -1;
            }else{
                lastPage = _currentPage-1;
            }
            MarxBannerViewPage *bannerViewPage = [self.datasource marxBannerView:self pageForPage:lastPage];
            [bannerViewPage setDelegate:self];
            [bannerViewPage setFrame:CGRectMake(0, 0, CGRectGetWidth(self.frame), CGRectGetHeight(self.frame))];
            [_scrollView addSubview:bannerViewPage];
            [_visiablePage insertObject:bannerViewPage atIndex:0];
        }
        
        if ([self.delegate respondsToSelector:@selector(marxBannerView:didScrollToPage:)]) {
            [self.delegate marxBannerView:self didScrollToPage:_currentPage];
        }
    }
}
#pragma mark ReloadData
- (void)reloadData
{
    [_visiablePage makeObjectsPerformSelector:@selector(removeFromSuperview)];
    [_reusablePage addObjectsFromArray:_visiablePage];
    [_visiablePage removeAllObjects];
    [self setNeedsLayout];
}

#pragma mark ReusablePage
- (MarxBannerViewPage *)dequeueReusablePageWithIdentifier:(NSString *)identifier
{
    MarxBannerViewPage *bannerViewPage = nil;
    for (MarxBannerViewPage *page in _reusablePage) {
        if ([page.reuseIdentifier isEqualToString:identifier]) {
            
            bannerViewPage = page;
            [bannerViewPage setNeedsLayout];
            break;
        }
    }
    [_reusablePage removeObject:bannerViewPage];
    
    return bannerViewPage;
}

#pragma mark MarxBannerViewPageDelegate
- (void)didSelectedMarxBannerViewPage:(MarxBannerViewPage *)bannerViewPage
{
    NSInteger page = _currentPage + [_visiablePage indexOfObject:bannerViewPage] -1;
    

    if ([self.delegate respondsToSelector:@selector(marxBannerView:didSelectPage:)]) {
        [self.delegate marxBannerView:self didSelectPage:page];
    }
}

@end
