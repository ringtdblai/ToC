//
//  LoginViewController.m
//  ToC
//
//  Created by LinYiting on 2016/10/13.
//  Copyright © 2016年 Mobiusbobs. All rights reserved.
//

#import "LoginViewController.h"
#import "AnchorUIMaker.h"
#import <Masonry.h>
#import <FBSDKLoginManager.h>
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>
#import "RACCommand+Extension.h"
#import "EmailViewController.h"

@interface LoginViewController ()

@property (nonatomic, weak) UIView *containerView;
@property (nonatomic, weak) UIImageView *iconImageView;
@property (nonatomic, weak) UILabel *titleLabel;
@property (nonatomic, weak) UIButton *fbLoginButton;
@property (nonatomic, weak) UIButton *rapidLoginButton;
@property (nonatomic, weak) UIButton *touButton;

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self constructViews];
    [self bindButtons];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Setup UI
- (void)constructViews
{
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"Vote With Pet";
    [self setupContainerView];
    [self setupIconImageView];
    [self setupTitleLabel];
    [self setupRapidLoginButton];
    [self setupTermOfUse];
}

- (void)setupContainerView
{
    UIView *containerView = [UIView new];
    [self.view addSubview:containerView];
    
    [containerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.view);
        make.left.equalTo(self.view).with.offset(48);
        make.right.equalTo(self.view).with.offset(-48);
    }];
    
    self.containerView = containerView;
}

- (void)setupIconImageView
{
    UIImageView *iconImageView = [UIImageView new];
    [iconImageView setImage:[UIImage imageNamed:@"trumpVSclinton"]];
    [self.view addSubview:iconImageView];
    
    [iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.containerView);
        make.centerX.equalTo(self.view);
        make.width.equalTo(self.view);
        make.height.equalTo(self.view.mas_width).dividedBy(667.0f/342.0f);
    }];
    
    self.iconImageView = iconImageView;
}


- (void)setupTitleLabel
{
    UILabel *titleLabel = [UILabel new];
    titleLabel.text = @"Vote for the Presidential Election 2016 with pet’s GIFs and see the latest poll result in real time";
    titleLabel.textColor = [UIColor blackColor];
    titleLabel.font = [UIFont fontWithName:@"Palatino"
                                      size:14.0f];
    
    
    titleLabel.numberOfLines = 0;
    titleLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:titleLabel];
    
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.iconImageView.mas_bottom).with.offset(30);
        make.centerX.equalTo(self.containerView);
        make.left.equalTo(self.view).with.offset(30);
        make.right.equalTo(self.view).with.offset(-30);
    }];
    
    self.titleLabel = titleLabel;
}

- (void)setupRapidLoginButton
{
    UIButton *rapidLoginButton = [AnchorUIMaker createRapidLoginButton];
    [rapidLoginButton setBackgroundColor:[UIColor colorWithRed:0.918 green:0.953 blue:0.965 alpha:1.000]];
    [self.containerView addSubview:rapidLoginButton];
    
    [rapidLoginButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.containerView);
        make.top.equalTo(self.titleLabel.mas_bottom).with.offset(30);
        make.height.equalTo(@52);
        make.bottom.equalTo(self.containerView);
    }];
    
    self.rapidLoginButton = rapidLoginButton;
}

- (void)setupTermOfUse
{
    UIButton *touButton = [UIButton buttonWithType:UIButtonTypeCustom];
    touButton.titleLabel.font = [UIFont systemFontOfSize:9.0f];
    touButton.titleLabel.numberOfLines = 0;
    [touButton setTitle:NSLocalizedString(@"Term Of Use", nil) forState:UIControlStateNormal];
    [touButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    
    touButton.rac_command = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://yiting6.wixsite.com/votewithpet/about"]];
        return [RACSignal empty];
    }];
    
    [self.view addSubview:touButton];
    
    [touButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.containerView);
        make.bottom.equalTo(self.view).with.offset(-10);
    }];
}

#pragma mark - Binding
- (void)bindButtons
{
    @weakify(self);
    self.rapidLoginButton.rac_command = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        return [RACSignal return:@1];
    }];
    
    [self.rapidLoginButton.rac_command subscribeAllNext:^{
        @strongify(self);
        [self goToEmailVC];
    }];
    
}

- (void)goToEmailVC
{
    EmailViewController *vc = [EmailViewController new];
    [self.navigationController pushViewController:vc animated:YES];
}


@end
