//
//  AnimationEditViewController.m
//  ToC
//
//  Created by ringtdblai on 2016/10/13.
//  Copyright © 2016年 Mobiusbobs. All rights reserved.
//

#import "AnimationEditViewController.h"

#import "ShareViewController.h"

// Third Party
#import <ReactiveCocoa/ReactiveCocoa.h>
#import <Masonry/Masonry.h>

// UI
#import "WBMaskedImageView.h"
#import "AnimationView.h"

// Other
#import "FaceManager.h"
#import "Animation+ExportGIF.h"



@interface AnimationEditViewController ()

@property (nonatomic, weak) AnimationView *imageView;
@property (nonatomic, weak) UIButton *createButton;
@property (nonatomic, weak) WBMaskedImageView *faceImageView;
@property (nonatomic, weak) CALayer *animationLayer;

@end

@implementation AnimationEditViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self constructView];
    [self bindData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Setup UI
- (void)constructView
{
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self setupImageView];
    [self setupCreateButton];
    [self setupFaceImageView];
}

- (void)setupImageView
{

    AnimationView *imageView = [AnimationView new];
    imageView.animation = self.animation;
    

    [self.view addSubview:imageView];

    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_topLayoutGuide);
        make.left.right.equalTo(self.view);
        make.height.equalTo(imageView.mas_width);
    }];

    self.imageView = imageView;
}


//- (void)setupImageView
//{
//
//    FLAnimatedImageView *imageView = [FLAnimatedImageView new];
//    
//    NSData *gifData = [NSData dataWithContentsOfURL:self.animation.gifURL];
//    FLAnimatedImage *gifImage = [FLAnimatedImage animatedImageWithGIFData:gifData];
//    
//    CGFloat ratio = 1;
//    
//    if (gifImage.size.width != 0) {
//        ratio = gifImage.size.height / gifImage.size.width;
//    }
//
//    [imageView setAnimatedImage:gifImage];
//    
//    [self.view addSubview:imageView];
//    
//    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(self.mas_topLayoutGuide);
//        make.left.right.equalTo(self.view);
//        make.height.equalTo(imageView.mas_width).multipliedBy(ratio);
//    }];
//    
//    self.imageView = imageView;
//}

- (void)setupCreateButton
{
    UIButton *createButton = [UIButton buttonWithType:UIButtonTypeCustom];
    
    [createButton setTitle:@"Start"
                  forState:UIControlStateNormal];
    [createButton setBackgroundColor:[UIColor colorWithRed:113.0/255.0
                                                     green:115.0/255.0
                                                      blue:237.0/255.0
                                                     alpha:1]];
    
    [createButton addTarget:self action:@selector(exportGIF) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:createButton];
    
    [createButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.view);
        make.height.equalTo(@44);
    }];
    
    self.createButton = createButton;
}

- (void)setupFaceImageView
{
    UIView *containerView = [UIView new];
    containerView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:containerView];
    
    [containerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.top.equalTo(self.imageView.mas_bottom);
        make.bottom.equalTo(self.createButton.mas_top);
    }];
    
    WBMaskedImageView *faceImageView = [WBMaskedImageView new];
    faceImageView.backgroundColor = [UIColor clearColor];
    
    UIImage *maskImage = [FaceManager sharedManager].maskImage;
    UIImage *selectedImage = [FaceManager sharedManager].selectedFace;
    
    CGFloat ratio = 1;
    if (maskImage && maskImage.size.width) {
         ratio = maskImage.size.height / maskImage.size.width;
    }
    
    faceImageView.maskImage = maskImage;
    faceImageView.originalImage = selectedImage;
    
    [containerView addSubview:faceImageView];
    
    [faceImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(containerView);
        make.bottom.equalTo(containerView).with.offset(-20);
        make.height.equalTo(containerView).with.offset(-20);
        make.width.equalTo(faceImageView.mas_height);
    }];
    
    self.faceImageView = faceImageView;
}

#pragma mark - Binding
- (void)bindData
{
    RAC(self.faceImageView, originalImage) = RACObserve([FaceManager sharedManager], selectedFace);
    RAC(self.faceImageView, maskImage) = RACObserve([FaceManager sharedManager], maskImage);
    
}

- (void)exportGIF
{
    @weakify(self);
    [self.animation exportGifWithCompletionHandler:^(NSURL *gifURL) {
        @strongify(self);
        ShareViewController *vc = [ShareViewController new];
        vc.sharedImageURL = gifURL;
        [self.navigationController pushViewController:vc animated:YES];
    }];
}

@end
