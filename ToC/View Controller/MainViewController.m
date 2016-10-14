//
//  MainViewController.m
//  ToC
//
//  Created by ringtdblai on 2016/10/13.
//  Copyright © 2016年 Mobiusbobs. All rights reserved.
//

#import "MainViewController.h"

// Third Party
#import <ReactiveCocoa/ReactiveCocoa.h>
#import <Masonry/Masonry.h>
#import <MaterialControls/MDTabBarViewController.h>

// View Controller
#import "AnimationListViewController.h"
#import "AddFaceViewController.h"

// UI
#import "WBMaskedImageView.h"

// Model
#import "FaceManager.h"

@interface MainViewController ()
<
    MDTabBarViewControllerDelegate
>

@property (nonatomic, weak) MDTabBarViewController *tabBarViewController;
@property (nonatomic, weak) WBMaskedImageView *faceImageView;
@end

@implementation MainViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self constructView];
    [self bindData];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - Setup UI

- (void)constructView
{
    [self setupTabBarViewController];
    [self setupAddFaceButton];
}

- (void)setupTabBarViewController
{
    MDTabBarViewController *tabBarViewController = [[MDTabBarViewController alloc] initWithDelegate:self];
    NSArray *items = @[NSLocalizedString(@"Both", nil),
                       NSLocalizedString(@"Clinton", nil),
                       NSLocalizedString(@"Trump", nil),
                       ];
    [tabBarViewController setItems:items];
    
    tabBarViewController.tabBar.backgroundColor = [UIColor clearColor];

    
    [self addChildViewController:tabBarViewController];
    [self.view addSubview:tabBarViewController.view];
    [tabBarViewController didMoveToParentViewController:self];
    
    [tabBarViewController.view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.left.right.equalTo(self.view);
        make.top.equalTo(self.mas_topLayoutGuide);
    }];
    
    self.tabBarViewController = tabBarViewController;
}

- (void)setupAddFaceButton
{
    WBMaskedImageView *imageView = [WBMaskedImageView new];
    imageView.contentMode = UIViewContentModeScaleAspectFit;
    [self.view addSubview:imageView];
    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.equalTo(@80);
        make.centerX.equalTo(self.view);
        make.bottom.equalTo(self.view).with.offset(-30);
    }];
    
    self.faceImageView = imageView;
    
    UIButton *faceButton = [UIButton buttonWithType:UIButtonTypeCustom];;
    [faceButton addTarget:self
                   action:@selector(showAddFaceVC)
         forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:faceButton];
    
    [faceButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(imageView);
    }];
    
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"currentFace"]) {
        NSString *name = [[NSUserDefaults standardUserDefaults] objectForKey:@"currentFace"];
        
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *documentsDirectory = [paths objectAtIndex:0];
        NSString *imagePath =[documentsDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.png",name]];
        
        UIImage *customImage = [UIImage imageWithContentsOfFile:imagePath];
        self.faceImageView.originalImage = customImage;
        self.faceImageView.maskImage = [UIImage imageNamed:@"catOutline"];
    } else {
        self.faceImageView.originalImage = [UIImage imageNamed:@"AddFace"];
        self.faceImageView.maskImage = [UIImage imageNamed:@"catOutline"];
    }
}

#pragma mark - Binding
- (void)bindData
{
    RAC(self.faceImageView, originalImage) = RACObserve([FaceManager sharedManager], selectedFace);
    RAC(self.faceImageView, maskImage) = RACObserve([FaceManager sharedManager], maskImage);
}

#pragma mark - MDTabBarViewController
- (UIViewController *)tabBarViewController:(MDTabBarViewController *)viewController
                     viewControllerAtIndex:(NSUInteger)index
{
    AnimationListViewController *vc = [AnimationListViewController new];
    vc.type = index;
    return vc;
}

- (void)showAddFaceVC
{
    AddFaceViewController *vc = [AddFaceViewController new];
    [self presentViewController:vc animated:YES completion:^{
        
    }];
}

@end
