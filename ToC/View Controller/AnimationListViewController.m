//
//  AnimationListViewController.m
//  ToC
//
//  Created by ringtdblai on 2016/10/12.
//  Copyright © 2016年 Mobiusbobs. All rights reserved.
//

#import "AnimationListViewController.h"

// Third Party
#import <ReactiveCocoa.h>
#import <Masonry.h>
#import <SDCycleScrollView.h>

// UI
#import "SquareAnimationCollectionViewCell.h"

// Model
#import "FaceManager.h"
#import "AnimationManager.h"
#import "Animation+ExportGIF.h"

// View Controller
#import "ShareViewController.h"
#import "AddFaceViewController.h"

@interface AnimationListViewController ()
<
    UICollectionViewDataSource,
    UICollectionViewDelegate,
    SDCycleScrollViewDelegate
>

@property (nonatomic, strong) NSArray *animations;

@property (nonatomic, weak) UIImageView *faceImageView;
@property (nonatomic, weak) UICollectionView *collectionView;
@property (nonatomic, weak) SDCycleScrollView *cycleScrollView;

@end

@implementation AnimationListViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    [self constructView];
    [self bindData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [[AnimationManager sharedManager] reload];
    [self.collectionView reloadData];
}

#pragma mark- Setup UI
- (void)constructView
{
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self setupTopLine];
    [self setupBanner];
    [self setupCollectionView];
    
    [self setupAddFaceButton];

}

- (void)setupTopLine
{
    UIView *topLineView = [UIView new];
    topLineView.backgroundColor = [UIColor blackColor];
    
    [self.view addSubview:topLineView];
    
    [topLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_topLayoutGuide);
        make.left.right.equalTo(self.view);
        make.height.equalTo(@0.5);
    }];
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

- (void)setupCollectionView
{
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    CGFloat width = (CGRectGetWidth([UIScreen mainScreen].bounds) - 6) / 2;
    layout.itemSize = CGSizeMake(width, width);
    layout.minimumLineSpacing = 2.0;
    layout.minimumInteritemSpacing = 2.0;
    
    layout.scrollDirection = UICollectionViewScrollDirectionVertical;
    
    UICollectionView *collectionView = [[UICollectionView alloc]initWithFrame:CGRectZero
                                                         collectionViewLayout:layout];
    
    collectionView.backgroundColor = [UIColor clearColor];
    
    [collectionView registerClass:[SquareAnimationCollectionViewCell class]
       forCellWithReuseIdentifier:squareAnimationCollectionViewCellIdentifier];
    
    collectionView.dataSource = self;
    collectionView.delegate = self;
    
    [self.view addSubview:collectionView];
    
    [collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.top.equalTo(self.mas_topLayoutGuide).with.offset(0.5);
        make.bottom.equalTo(self.cycleScrollView.mas_top);
    }];
    
    self.collectionView = collectionView;
}

- (void)setupAddFaceButton
{
    
    
    UIImageView *imageView = [UIImageView new];
    imageView.contentMode = UIViewContentModeScaleAspectFit;
    [self.view addSubview:imageView];
    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.equalTo(@160);
        make.centerX.equalTo(self.view);
        make.bottom.equalTo(self.cycleScrollView.mas_top).with.offset(-5);
    }];
    
    self.faceImageView = imageView;
    
    UIImageView *border = [UIImageView new];
    border.image = [UIImage imageNamed:@"cropImage"];
    [self.view addSubview:border];
    [border mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.equalTo(@165);
        make.center.equalTo(imageView);
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
    
}

#pragma mark - Bind Data
- (void)bindData
{
    RACSignal *cAnimations = [[RACObserve([AnimationManager sharedManager], cAnimations)
                              ignore:nil] startWith:@[]];

    RACSignal *tAnimations = [[RACObserve([AnimationManager sharedManager], tAnimations)
                              ignore:nil] startWith:@[]];
    
    RACSignal *bothAnimations = [[RACObserve([AnimationManager sharedManager], bothAnimations)
                              ignore:nil] startWith:@[]];
    
    RACSignal *typeSignal = [RACObserve(self, type) ignore:nil];
    
    RAC(self, animations) =
    [RACSignal combineLatest:@[cAnimations,
                               tAnimations,
                               bothAnimations,
                               typeSignal]
                      reduce:^id(NSArray *cAnimations,
                                 NSArray *tAnimations,
                                 NSArray *bothAnimations,
                                 NSNumber *type)
     {
         NSMutableArray *array = [NSMutableArray array];
         
         switch ([type integerValue]) {
             case AnimationTypeClinton:
                 [array addObjectsFromArray:cAnimations];
                 [array addObjectsFromArray:bothAnimations];
                 break;
             case AnimationTypeTrump:
                 [array addObjectsFromArray:tAnimations];
                 [array addObjectsFromArray:bothAnimations];
                 break;
             default:
                 [array addObjectsFromArray:bothAnimations];
                 break;
         }
         return array;
     }];
    
    @weakify(self);
    [[RACObserve(self, animations) ignore:nil] subscribeNext:^(id x) {
        @strongify(self);
        [self.collectionView reloadData];
    }];
    
    RAC(self.faceImageView, image) = RACObserve([FaceManager sharedManager], maskedImage);
}

#pragma mark - UICollectionView Delegate
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [self.animations count];
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    SquareAnimationCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:squareAnimationCollectionViewCellIdentifier
                                                                           forIndexPath:indexPath];
    
    GifAnimation *animation = self.animations[indexPath.row];
    [cell updateWithAnimation:animation];
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    Animation *animation = self.animations[indexPath.row];

    @weakify(self);
    [animation exportGifWithCompletionHandler:^(NSURL *gifURL) {
        @strongify(self);
        ShareViewController *vc = [ShareViewController new];
        vc.sharedImageURL = gifURL;
        [self.navigationController pushViewController:vc animated:YES];
    }];
    
}

#pragma mark - Button Action

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
