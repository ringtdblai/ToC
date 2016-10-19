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
#import <SDCycleScrollView.h>

// View Controller
#import "AnimationListViewController.h"
#import "AddFaceViewController.h"

// UI
#import "WBMaskedImageView.h"
#import "TextStyles.h"

// Model
#import "FaceManager.h"

@interface MainViewController ()
<
    MDTabBarViewControllerDelegate,
    SDCycleScrollViewDelegate
>

@property (nonatomic, weak) UIView *containerView;
@property (nonatomic, weak) UIImageView *imageView;
@property (nonatomic, weak) UILabel *currentStateLabel;
@property (nonatomic, weak) UILabel *nameLabel;
@property (nonatomic, weak) UILabel *totalCountLabel;

@property (nonatomic, weak) UIView *buttonView;
@property (nonatomic, weak) UIButton *clintonButton;
@property (nonatomic, weak) UIButton *trumpButton;

@property (nonatomic, weak) MDTabBarViewController *tabBarViewController;
@property (nonatomic, weak) WBMaskedImageView *faceImageView;
@property (nonatomic, weak) SDCycleScrollView *cycleScrollView;
@end

@implementation MainViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self constructView];
    [self bindData];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - Setup UI

- (void)constructView
{
    self.title = @"ToC";
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self setupBanner];
    [self setupButtonView];
    [self setupContainerView];
    
//    [self setupTabBarViewController];
//    [self setupAddFaceButton];
}

- (void)setupBanner
{
    float bannerHeight = floorf(90.0f*self.view.frame.size.width/728.0f);
    UIImage *image1 = [UIImage imageNamed:NSLocalizedString(@"ad1", nil)];
    UIImage *image2 = [UIImage imageNamed:NSLocalizedString(@"ad2", nil)];
    UIImage *image3 = [UIImage imageNamed:NSLocalizedString(@"ad3", nil)];
    
    SDCycleScrollView *cycleScrollView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, self.view.frame.size.height - bannerHeight - 64, [UIScreen mainScreen].bounds.size.width, bannerHeight)
                                                                     imageNamesGroup:@[image1,image2,image3]];
    
    cycleScrollView.bannerImageViewContentMode = UIViewContentModeScaleAspectFill;
    cycleScrollView.showPageControl = NO;
    cycleScrollView.delegate = self;
    
    [self.view addSubview:cycleScrollView];
    self.cycleScrollView = cycleScrollView;
}

- (void)setupButtonView
{
    UIView *buttonView = [UIView new];
    
    [self.view addSubview:buttonView];
    
    [buttonView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.bottom.equalTo(self.cycleScrollView.mas_top).with.offset(-40);
        make.height.equalTo(@38);
    }];
    
    self.buttonView = buttonView;
    
    [self setupClintonButton];
    [self setupTrumpButton];
}

- (void)setupClintonButton
{
    UIButton *clintonButton = [UIButton buttonWithType:UIButtonTypeCustom];
    clintonButton.tag = AnimationTypeClinton;
    
    [clintonButton setAttributedTitle:[self titleWithName:@"Clinton"]
                             forState:UIControlStateNormal];
    [clintonButton setBackgroundColor:[TextStyles clintonTintColor]];
    
    
    [clintonButton addTarget:self
                      action:@selector(navigateWithType:)
            forControlEvents:UIControlEventTouchUpInside];
    
    [self.buttonView addSubview:clintonButton];
    
    [clintonButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(self.buttonView).multipliedBy(0.5);
        make.left.top.bottom.equalTo(self.buttonView);
    }];
    
    self.clintonButton = clintonButton;
}

- (void)setupTrumpButton
{
    UIButton *trumpButton = [UIButton buttonWithType:UIButtonTypeCustom];
    trumpButton.tag = AnimationTypeTrump;
    
    [trumpButton setAttributedTitle:[self titleWithName:@"Trump"]
                             forState:UIControlStateNormal];
    [trumpButton setBackgroundColor:[TextStyles trumpTintColor]];
    
    [trumpButton addTarget:self
                      action:@selector(navigateWithType:)
            forControlEvents:UIControlEventTouchUpInside];

    
    [self.buttonView addSubview:trumpButton];
    
    [trumpButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(self.buttonView).multipliedBy(0.5);
        make.right.top.bottom.equalTo(self.buttonView);
        make.left.equalTo(self.clintonButton.mas_right);
    }];
    
    self.clintonButton = trumpButton;
}

- (NSAttributedString *)titleWithName:(NSString *)name
{
    NSMutableParagraphStyle *style = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
    [style setAlignment:NSTextAlignmentCenter];
    [style setLineBreakMode:NSLineBreakByWordWrapping];
    
    UIFont *font1 = [UIFont fontWithName:@"TimesNewRomanPS-BoldMT" size:10.0f];
    UIFont *font2 = [UIFont fontWithName:@"TimesNewRomanPS-BoldMT"  size:24.0f];
    
    UIColor *color = [UIColor whiteColor];
    
    NSDictionary *dict1 = @{NSFontAttributeName:font1,
                            NSParagraphStyleAttributeName:style,
                            NSForegroundColorAttributeName : color};
    NSDictionary *dict2 = @{NSFontAttributeName:font2,
                            NSParagraphStyleAttributeName:style,
                            NSForegroundColorAttributeName : color};
    
    NSMutableAttributedString *attString = [[NSMutableAttributedString alloc] init];
    [attString appendAttributedString:[[NSAttributedString alloc] initWithString:@"Vote for "
                                                                      attributes:dict1]];
    [attString appendAttributedString:[[NSAttributedString alloc] initWithString:name
                                                                      attributes:dict2]];
    
    return attString;
}

- (void)setupContainerView
{
    UIView *containerView = [UIView new];
    
    [self.view addSubview:containerView];
    
    [containerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.top.equalTo(self.mas_topLayoutGuide);
        make.bottom.equalTo(self.buttonView.mas_top);
    }];
    
    self.containerView = containerView;
    
    [self setupImageView];
    [self setupCurrentStateLabel];
    [self setupNameLabel];
    [self setupTotalCountLabel];
}

- (void)setupImageView
{
    UIImageView *imageView = [UIImageView new];
    
    UIImage *image = [UIImage imageNamed:@"trumpVSclinton"];
    CGFloat ratio = image.size.height / image.size.width;
    
    imageView.image = image;
    
    [self.containerView addSubview:imageView];
    
    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.containerView);
        make.width.equalTo(self.containerView);
        make.height.equalTo(imageView.mas_width).multipliedBy(ratio);
    }];
    
    self.imageView = imageView;
}

- (void)setupCurrentStateLabel
{
    UILabel *label = [UILabel new];
    
    label.textColor = [TextStyles currentStateTitleColor];
    label.text = @"52％：48％";
    label.font = [UIFont fontWithName:@"Palatino-Bold"
                                 size:26];
    
    [self.containerView addSubview:label];
    
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.imageView);
        make.bottom.equalTo(self.imageView.mas_top);
    }];
    
    self.currentStateLabel = label;
}

- (void)setupNameLabel
{
    UILabel *label = [UILabel new];
    
    label.textColor = [TextStyles currentStateTitleColor];
    label.text = @"Clinton v.s.Trump";
    label.font = [UIFont fontWithName:@"SnellRoundhand"
                                 size:18];
    
    [self.containerView addSubview:label];
    
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.imageView);
        make.top.equalTo(self.imageView.mas_centerY);
    }];
    
    self.nameLabel = label;
}

- (void)setupTotalCountLabel
{
    UIView *view = [UIView new];
    [self.containerView addSubview:view];
    
    [view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.containerView);
        make.top.equalTo(self.imageView.mas_bottom);
    }];
    
    UILabel *label = [UILabel new];
    
    label.textColor = [TextStyles currentStateTitleColor];
    label.attributedText = [self titleWithCount:250000];
    label.numberOfLines = 0;
    
    [view addSubview:label];
    
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(view);
    }];
    
    self.totalCountLabel = label;
}

- (NSAttributedString *)titleWithCount:(NSUInteger)count
{
    NSMutableParagraphStyle *style = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
    [style setAlignment:NSTextAlignmentCenter];
    [style setLineBreakMode:NSLineBreakByWordWrapping];
    
    UIFont *font1 = [UIFont fontWithName:@"TimesNewRomanPS-BoldMT" size:18.0f];
    UIFont *font2 = [UIFont fontWithName:@"TimesNewRomanPS-BoldMT"  size:12.0f];
    
    UIColor *color1 = [TextStyles clintonTintColor];
    UIColor *color2 = [UIColor blackColor];

    NSDictionary *dict1 = @{NSFontAttributeName:font1,
                            NSParagraphStyleAttributeName:style,
                            NSForegroundColorAttributeName : color1};
    NSDictionary *dict2 = @{NSFontAttributeName:font2,
                            NSParagraphStyleAttributeName:style,
                            NSForegroundColorAttributeName : color2};
    
    NSString *countString = [NSString stringWithFormat:@"%ld%@", count > 1000 ? count/1000 : count,
                                                                 count > 1000 ? @"k" : @""];
    NSMutableAttributedString *attString = [[NSMutableAttributedString alloc] init];
    [attString appendAttributedString:[[NSAttributedString alloc] initWithString:countString
                                                                      attributes:dict1]];
    [attString appendAttributedString:[[NSAttributedString alloc] initWithString:@" animals\n vote for America"
                                                                      attributes:dict2]];
    
    return attString;
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
        make.left.right.equalTo(self.view);
        make.top.equalTo(self.mas_topLayoutGuide);
        make.bottom.equalTo(self.cycleScrollView.mas_top);
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

#pragma mark - Button Action

- (void)navigateWithType:(id)sender
{
    UIButton *button = (UIButton *) sender;
    AnimationListViewController *vc = [AnimationListViewController new];
    vc.type = button.tag;
    
    [self.navigationController pushViewController:vc
                                         animated:YES];
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

#pragma mark - SDCycleScrollView Delegate
- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index
{
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://taps.io/Bboowji2"]];
}


@end
