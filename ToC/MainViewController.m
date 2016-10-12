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

@interface MainViewController ()
<
    UICollectionViewDataSource,
    UICollectionViewDelegate
>

@property (nonatomic, weak) UICollectionView *collectionView;

@end

@implementation MainViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self constructView];
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
    
    UICollectionView *collectionView = [[UICollectionView alloc]initWithFrame:CGRectZero collectionViewLayout:layout];
    
    collectionView.backgroundColor = [UIColor clearColor];
    [collectionView registerClass:[UICollectionViewCell class]
       forCellWithReuseIdentifier:@"cell"];
    
    collectionView.dataSource = self;
    collectionView.delegate = self;
    
    [self.view addSubview:collectionView];
    
    [collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
    self.collectionView = collectionView;
}

#pragma mark - UICollectionView Delegate
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return 10;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell"
                                                                           forIndexPath:indexPath];
    
    cell.backgroundColor = [UIColor colorWithRed:(arc4random()%255)/255.0
                                           green:(arc4random()%255)/255.0
                                            blue:(arc4random()%255)/255.0
                                           alpha:1.0];
    
    return cell;
}



@end
