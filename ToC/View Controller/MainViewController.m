//
//  MainViewController.m
//  ToC
//
//  Created by ringtdblai on 2016/10/13.
//  Copyright © 2016年 Mobiusbobs. All rights reserved.
//

#import "MainViewController.h"

// Third Party
#import <Masonry/Masonry.h>
#import <MaterialControls/MDTabBarViewController.h>

#import "AnimationListViewController.h"


@interface MainViewController ()
<
    MDTabBarViewControllerDelegate
>

@property (nonatomic, weak) MDTabBarViewController *tabBarViewController;

@end

@implementation MainViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self constructView];
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
        make.top.equalTo(self.view).with.offset(64);
    }];
    
    self.tabBarViewController = tabBarViewController;
}

#pragma mark - MDTabBarViewController
- (UIViewController *)tabBarViewController:(MDTabBarViewController *)viewController
                     viewControllerAtIndex:(NSUInteger)index
{
    AnimationListViewController *vc = [AnimationListViewController new];
    vc.type = index;
    return vc;
}

@end
