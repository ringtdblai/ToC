//
//  ShareViewController.m
//  Pamily
//
//  Created by LinYiting on 2016/9/13.
//  Copyright © 2016年 Pamily. All rights reserved.
//

#import "ShareViewController.h"

#import <AssetsLibrary/ALAssetRepresentation.h>

// Third Party
#import <ReactiveCocoa.h>
#import <Masonry.h>

#import <FBSDKShareKit/FBSDKShareKit.h>
#import <FBSDKMessengerShareKit/FBSDKMessengerShareKit.h>
#import <Social/Social.h>
#import <MBProgressHUD.h>
#import <MessageUI/MessageUI.h>
#import <FLAnimatedImageView.h>
#import <FLAnimatedImage.h>

@interface ShareViewController ()
<
    UICollectionViewDelegate,
    UICollectionViewDataSource,
    MFMessageComposeViewControllerDelegate,
    MFMailComposeViewControllerDelegate,
    FBSDKSharingDelegate,
    UIDocumentInteractionControllerDelegate
>

@property (nonatomic, weak) UIView *topView;
@property (nonatomic, weak) UIButton *dismissButton;
@property (nonatomic, weak) UICollectionView *collectionView;

@property (nonatomic, strong) NSArray *dataArray;
@property (nonatomic, strong) UIDocumentInteractionController *dic;

@end

@implementation ShareViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self constructView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationNone];
}

- (void)constructView
{
    self.view.backgroundColor = [UIColor colorWithRed:0.961 green:0.965 blue:0.969 alpha:1.000];
    
//    UIButton *closeButton = [UIButton buttonWithType:UIButtonTypeCustom];
//    [closeButton setImage:[UIImage imageNamed:@"btnCloseShoot"] forState:UIControlStateNormal];
//    [self.view addSubview:closeButton];
//    
//    [closeButton mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.width.height.equalTo(@40);
//        make.top.left.equalTo(self.view).with.offset(10);
//    }];
//    [closeButton addTarget:self action:@selector(clickClose) forControlEvents:UIControlEventTouchUpInside];
    
    [self setupTopView];
    
}

- (void)setupTopView
{
    UIView *topView = [UIView new];
    
    [self.view addSubview:topView];
    [topView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.equalTo(self.view.mas_width);
        make.top.equalTo(self.mas_topLayoutGuide);
    }];
    
    self.topView = topView;
    
    FLAnimatedImageView *imageView = [FLAnimatedImageView new];
    
    NSData *gifData = [NSData dataWithContentsOfURL:self.sharedImageURL];
    FLAnimatedImage *gifImage = [FLAnimatedImage animatedImageWithGIFData:gifData];

    imageView.animatedImage = gifImage;
    
    [topView addSubview:imageView];
    
    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(topView);
    }];
    
}

@end
