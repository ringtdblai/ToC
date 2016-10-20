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
    [self setupFacebookLoginButton];
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
    titleLabel.text = @"Please Login To Use";
    titleLabel.textColor = [UIColor blackColor];
    titleLabel.font = [UIFont systemFontOfSize:16.0f];
    
    
    titleLabel.numberOfLines = 0;
    titleLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:titleLabel];
    
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.iconImageView.mas_bottom).with.offset(9);
        make.left.equalTo(self.containerView);
        make.right.equalTo(self.containerView);
    }];
    
    self.titleLabel = titleLabel;
}

- (void)setupFacebookLoginButton
{
    UIButton *fbLoginButton = [AnchorUIMaker createFacebookLoginButton];
    
    [self.containerView addSubview:fbLoginButton];
    
    [fbLoginButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.containerView);
        make.top.equalTo(self.titleLabel.mas_bottom).with.offset(31);
        make.height.equalTo(@52);
    }];
    
    self.fbLoginButton = fbLoginButton;
}

- (void)setupRapidLoginButton
{
    UIButton *rapidLoginButton = [AnchorUIMaker createRapidLoginButton];
    [rapidLoginButton setBackgroundColor:[UIColor colorWithRed:0.918 green:0.953 blue:0.965 alpha:1.000]];
    [self.containerView addSubview:rapidLoginButton];
    
    [rapidLoginButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(self.fbLoginButton);
        make.left.right.equalTo(self.containerView);
        make.top.equalTo(self.fbLoginButton.mas_bottom).with.offset(14);
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
    self.fbLoginButton.rac_command = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        @strongify(self);
        return [self loginByFacebookWithViewController:self];
    }];
    
    [self.fbLoginButton.rac_command displayProgressHUDWhileExecutingInView:self.view];
    
    [self.fbLoginButton.rac_command
     displayErrorInAlertViewWithTitle:NSLocalizedString(@"Login_Fail", nil)];
    
    [self.fbLoginButton.rac_command subscribeAllNext:^{
        [[NSUserDefaults standardUserDefaults] setObject:@"facebook" forKey:@"email"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        [self dismissViewControllerAnimated:YES completion:nil];
    }];
    
    self.rapidLoginButton.rac_command = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        return [RACSignal return:@1];
    }];
    
    [self.rapidLoginButton.rac_command displayProgressHUDWhileExecutingInView:self.view];
    
    [self.rapidLoginButton.rac_command
     displayErrorInAlertViewWithTitle:NSLocalizedString(@"Login_Fail", nil)];
    
    [self.rapidLoginButton.rac_command subscribeAllNext:^{
        @strongify(self);
        [self goToEmailVC];
    }];
    
}

- (RACSignal *)loginByFacebookWithViewController:(UIViewController *)viewController
{
    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        FBSDKLoginManager *login = [[FBSDKLoginManager alloc] init];
        [login logInWithReadPermissions:@[@"public_profile",
                                          @"email",
                                          @"user_friends"]
                     fromViewController:viewController
                                handler:^(FBSDKLoginManagerLoginResult *result, NSError *error)
         {
             if (error) {
                 [subscriber sendError:error];
                 return;
             }
             
             if (result.isCancelled) {
                 NSError *error = [self errorForCode:FBSDKLoginManagerErrorCancel];
                 [subscriber sendError:error];
                 return;
             }
             
             if (![result.grantedPermissions containsObject:@"email"] ||
                 ![result.grantedPermissions containsObject:@"public_profile"] ||
                 ![result.grantedPermissions containsObject:@"user_friends"])
             {
                 NSError *error = [self errorForCode:FBSDKLoginManagerErrorNeedPermission];
                 [subscriber sendError:error];
                 return;
             }
             [FBSDKAccessToken setCurrentAccessToken:result.token];
             [subscriber sendNext:result];
             [subscriber sendCompleted];
         }];
        
        return nil;
    }];

    
}

- (NSError *)errorForCode:(FBSDKLoginManagerErrorCode)code
{
    NSString *discription;
    
    switch (code) {
            case FBSDKLoginManagerErrorCancel:
            discription = NSLocalizedString(@"Facebook_Login_Cancelled", nil);
            break;
            case FBSDKLoginManagerErrorNeedPermission:
            discription = NSLocalizedString(@"Facebook_Login_Need_Permission", nil);
            break;
        default:
            break;
    }
    
    NSDictionary *userInfo = @{NSLocalizedDescriptionKey : discription};
    return  [NSError errorWithDomain:@"FBSDKLoginManager"
                                code:code
                            userInfo:userInfo];
}


- (void)goToEmailVC
{
    EmailViewController *vc = [EmailViewController new];
    [self.navigationController pushViewController:vc animated:YES];
}


@end
