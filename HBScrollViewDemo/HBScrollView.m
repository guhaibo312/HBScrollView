//
//  HBScrollView.m
//  HBScrollViewDemo
//
//  Created by guhaibo on 16/5/5.
//  Copyright © 2016年 guahibo. All rights reserved.
//

#import "HBScrollView.h"
#import "UIImageView+WebCache.h"

@interface HBScrollView()<UIScrollViewDelegate>

//本地图片数组
@property(nonatomic,strong) NSMutableArray *localImages;

//广告
@property(nonatomic,strong) UIScrollView *scrollView;

//分页
@property(nonatomic,strong) UIPageControl *pageControl;

//计时器
@property(nonatomic,strong) NSTimer *advertiseTimer;

//是否是本地图片
@property(nonatomic,assign) BOOL isLocal;

//当前图片索引
@property(nonatomic,assign) int currentIndex;

@end

@implementation HBScrollView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.scrollView = [[UIScrollView alloc] init];
        self.scrollView.delegate = self;
        [self addSubview:self.scrollView];
        
        //关闭水平和垂直滚动条
        self.scrollView.showsHorizontalScrollIndicator = NO;
        self.scrollView.showsVerticalScrollIndicator = NO;
        
        //分页效果
        self.scrollView.pagingEnabled = YES;
        
        //关闭弹簧效果
        self.scrollView.bounces = NO;
        
        self.pageControl = [[UIPageControl alloc] init];
        
        //pageControl默认颜色
        self.pageControl.pageIndicatorTintColor = [UIColor whiteColor];
        
        //pageControl选中颜色
        self.pageControl.currentPageIndicatorTintColor = [UIColor orangeColor];
        
        [self.pageControl addTarget:self action:@selector(pageControlClick :) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:self.pageControl];
        
        self.currentIndex = 0;
        self.advertiseTimer = [NSTimer timerWithTimeInterval:1 target:self selector:@selector(advertiseTimerChange) userInfo:nil repeats:YES];

        [[NSRunLoop currentRunLoop] addTimer:self.advertiseTimer forMode:NSDefaultRunLoopMode];
    }
    return self;
}

- (void)setLocalAdvertisements:(NSArray *)localAdvertisements
{
    _localAdvertisements = localAdvertisements;
    
    [self setImageView:self.localAdvertisements isLocal:YES];
}

- (void)setNetworkAdvertisements:(NSArray *)networkAdvertisements
{
    _networkAdvertisements = networkAdvertisements;
    
    [self setImageView:self.networkAdvertisements isLocal:NO];
}

- (void) setImageView : (NSArray *) images isLocal : (BOOL) isLocal
{
    self.isLocal = isLocal;
    
    int count = (int) images.count;
    if (count == 0) {return;}
    
    self.localImages = [NSMutableArray arrayWithCapacity : count];
    
    for (NSString *imageName in images) {
        
        UIImageView *imageView = [[UIImageView alloc] init];
        
        if (!isLocal) {
            [imageView sd_setImageWithURL:[NSURL URLWithString:imageName] placeholderImage:[UIImage imageNamed:@""]];
        }else
        {
            imageView.image = [UIImage imageNamed:imageName];
        }
        
        [self.scrollView addSubview:imageView];
        [self.localImages addObject:imageView];
    }
    
    self.scrollView.contentSize = CGSizeMake(self.frame.size.width * count, 0);
    
    self.pageControl.numberOfPages = count;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    int count = (int) self.localImages.count;
    if (count == 0) {return;}

    self.scrollView.frame = self.bounds;
    
    CGFloat imageViewW = self.scrollView.frame.size.width;
    CGFloat imageViewH = self.scrollView.frame.size.height;
    
    for (int i = 0; i < count; i ++) {
        UIImageView *imageView = self.localImages[i];
        imageView.frame = CGRectMake(i * imageViewW, 0, imageViewW, imageViewH);
    }
    
    CGFloat pageControlW = 50;
    CGFloat pageControlH = 20;
    
    self.pageControl.frame = CGRectMake(imageViewW * 0.5 - pageControlW * 0.5, imageViewH - pageControlH * 1.3, pageControlW, pageControlH);
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    int index = (int)(scrollView.contentOffset.x / scrollView.frame.size.width + 0.5);
    self.pageControl.currentPage = index;
    
    if (self.pageControl.currentPage != self.currentIndex) {
        self.currentIndex = (int)self.pageControl.currentPage;
    }
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self.advertiseTimer invalidate];
}

- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset
{
    self.advertiseTimer = [NSTimer timerWithTimeInterval:1 target:self selector:@selector(advertiseTimerChange) userInfo:nil repeats:YES];
    
    [[NSRunLoop currentRunLoop] addTimer:self.advertiseTimer forMode:NSDefaultRunLoopMode];
}

#pragma mark pageControl点击
- (void) pageControlClick : (UIPageControl *) pageControl
{
    if (pageControl.currentPage != self.currentIndex) {
        self.currentIndex = (int)pageControl.currentPage;
    }
    
    int index = (int)pageControl.currentPage;
    [self.scrollView setContentOffset:CGPointMake(index * self.scrollView.frame.size.width, 0) animated:YES];
}

#pragma mark 计时器每隔一秒调用一次
- (void) advertiseTimerChange
{
    self.currentIndex ++;
    
    int count = (int)(self.isLocal ? self.localAdvertisements.count : self.networkAdvertisements.count);
    
    if (self.currentIndex >= count){
        self.currentIndex = 0;
    }
    
    self.pageControl.currentPage = self.currentIndex;
    
    [self pageControlClick:self.pageControl];
}

@end
