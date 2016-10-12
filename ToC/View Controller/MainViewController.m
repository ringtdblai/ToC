//
//  MainViewController.m
//  ToC
//
//  Created by ringtdblai on 2016/10/12.
//  Copyright © 2016年 Mobiusbobs. All rights reserved.
//

#import "MainViewController.h"

// Third Party
#import <ReactiveCocoa.h>
#import <Masonry.h>

// UI
#import "SquareAnimationCollectionViewCell.h"

// Model
#import "AnimationManager.h"

@interface MainViewController ()
<
    UICollectionViewDataSource,
    UICollectionViewDelegate
>

@property (nonatomic, strong) NSArray *animations;
@property (nonatomic, weak) UICollectionView *collectionView;

@end

@implementation MainViewController

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

#pragma mark- Setup UI
- (void)constructView
{
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self setupCollectionView];
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
        make.edges.equalTo(self.view);
    }];
    
    self.collectionView = collectionView;
}

#pragma mark - Bind Data
- (void)bindData
{
    RACSignal *cAnimations = [RACObserve([AnimationManager sharedManager], cAnimations)
                              ignore:nil];

    RACSignal *tAnimations = [RACObserve([AnimationManager sharedManager], tAnimations)
                              ignore:nil];
    
    RAC(self, animations) =
    [RACSignal combineLatest:@[cAnimations, tAnimations]
                      reduce:^id(NSArray *cAnimations, NSArray *tAnimations)
     {
         NSMutableArray *array = [NSMutableArray array];
         
         [array addObjectsFromArray:cAnimations];
         [array addObjectsFromArray:tAnimations];
         
         return array;
     }];
    
    @weakify(self);
    [[RACObserve(self, animations) ignore:nil] subscribeNext:^(id x) {
        @strongify(self);
        [self.collectionView reloadData];
    }];
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
    
    Animation *animation = self.animations[indexPath.row];
    [cell updateWithAnimation:animation];
    
    return cell;
}



@end
