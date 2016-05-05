//
//  ViewController.m
//  HBScrollViewDemo
//
//  Created by guhaibo on 16/5/5.
//  Copyright © 2016年 guahibo. All rights reserved.
//

#import "ViewController.h"
#import "HBScrollView.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    HBScrollView *hbScrollView = [[HBScrollView alloc] initWithFrame:CGRectMake(0, 64, [UIScreen mainScreen].bounds.size.width, 200)];
    
    //本地图片
//    hbScrollView.localAdvertisements = @[@"image0",@"image1",@"image2",@"image3",@"image4"];
    
    //网络图片
    hbScrollView.networkAdvertisements = @[@"http://s1.dwstatic.com/group1/M00/DF/91/6d1314617bbe6ee75eb2836d7adc6267.jpg",@"http://s1.dwstatic.com/group1/M00/10/11/cab26f4f6f25b52c1db012b2b3ff97d5.jpg", @"http://s1.dwstatic.com/group1/M00/FF/3F/3b64431541bf9249caa11dc463e170a2.jpg"];
    
    [self.view addSubview:hbScrollView];
}


@end
