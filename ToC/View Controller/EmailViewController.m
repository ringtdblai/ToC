//
//  EmailViewController.m
//  ToC
//
//  Created by LinYiting on 2016/10/13.
//  Copyright © 2016年 Mobiusbobs. All rights reserved.
//

#import "EmailViewController.h"
// Third Party
#import <Masonry.h>
#import <MBProgressHUD.h>
#import <ReactiveCocoa.h>
#import "KeyboardNotificationHelper.h"
#import "ViewDecorator.h"
#import "RACCommand+Extension.h"

@interface EmailViewController ()
<
    UITextFieldDelegate
>

@property (nonatomic, weak) UIView *contentView;
@property (nonatomic, weak) UIImageView *iconImageView;
@property (nonatomic, weak) UILabel *titleLabel;
@property (nonatomic, weak) UILabel *descriptionLabel;
@property (nonatomic, weak) UITextField *nameTextField;
@property (nonatomic, weak) UIButton *getStartedButton;

@property (nonatomic, strong) RACCommand *confirmCommand;

@property (nonatomic, strong) KeyboardNotificationHelper *keyboardHelper;

@end

@implementation EmailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self constructView];
    [self bindConfirmCommand];
    [self bindButton];
    
    self.keyboardHelper = [[KeyboardNotificationHelper alloc] initWithView:self.view];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.keyboardHelper registerKeyboardNotifications];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [self.keyboardHelper unregisterKeyboardNotifications];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)constructView
{
    self.view.backgroundColor = [UIColor colorWithWhite:0.961 alpha:1.000];

    
    // content
    [self setupContent];
    
}

- (void)setupContent
{
    // contentView
    UIView *contentView = [UIView new];
    [self.view addSubview:contentView];
    [contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.view);
    }];
    
    self.contentView = contentView;
    
    // image
    [self setupImageIcon];
    
    // text field
    [self setupTextField];
    
    // done button
    [self setupGetStartedButton];
    
}

- (void)setupImageIcon
{
    UIImageView *iconImageView = [UIImageView new];
    [self.contentView addSubview:iconImageView];
    
    [iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView);
        make.width.height.equalTo(@136);
        make.centerX.equalTo(self.contentView);
    }];
    iconImageView.layer.cornerRadius = 68;
    iconImageView.clipsToBounds = YES;
    iconImageView.layer.borderColor = [UIColor whiteColor].CGColor;
    iconImageView.layer.borderWidth = 10;
    
    self.iconImageView = iconImageView;
    
}

- (void)setupTextField
{
    UITextField *nameTextField = [UITextField new];
    nameTextField.backgroundColor = [UIColor clearColor];
    nameTextField.textColor = [UIColor blackColor];
    nameTextField.font = [UIFont systemFontOfSize:14.0f];
    nameTextField.placeholder = @"Your Email";
    nameTextField.autocorrectionType = UITextAutocorrectionTypeNo;
    nameTextField.autocapitalizationType = UITextAutocapitalizationTypeNone;
    nameTextField.returnKeyType = UIReturnKeyGo;
    nameTextField.layer.sublayerTransform = CATransform3DMakeTranslation(25, 0, 0);
    nameTextField.delegate = self;
    
    [self.contentView addSubview:nameTextField];
    
    [nameTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.iconImageView.mas_bottom).with.offset(45);
        make.width.equalTo(@247);
        make.height.equalTo(@45);
        make.centerX.equalTo(self.contentView);
    }];
    self.nameTextField = nameTextField;
    
    UIImageView *iconProfile = [UIImageView new];
    iconProfile.image = [UIImage imageNamed:@"iconFastLogin"];
    [self.contentView addSubview:iconProfile];
    
    [iconProfile mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(nameTextField);
        make.width.equalTo(@16);
        make.height.equalTo(@16);
        make.centerY.equalTo(nameTextField);
    }];
    
    
    [ViewDecorator drawBottomLineInView:nameTextField withMargin:0 andColor:[UIColor colorWithWhite:0.282 alpha:1.000]];
    
}

- (void)setupGetStartedButton
{
    UIButton *getStartedButton = [UIButton buttonWithType:UIButtonTypeCustom];
    
    UIColor *defaultColor = [UIColor colorWithRed:0.467 green:0.663 blue:0.933 alpha:1.000];
    
//    UIColor *disabledColor = [UIColor colorWithWhite:0.000 alpha:0.300];
    
    [getStartedButton setBackgroundColor:defaultColor];
    
    [getStartedButton setTitle:NSLocalizedString(@"Get Started", nil)
                      forState:UIControlStateNormal];
    [getStartedButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    getStartedButton.titleLabel.font = [UIFont boldSystemFontOfSize:16.0f];
    
    getStartedButton.layer.cornerRadius = 4.0f;
    getStartedButton.clipsToBounds = YES;
    
    [self.view addSubview:getStartedButton];
    [getStartedButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.contentView);
        make.height.equalTo(@48);
        make.top.equalTo(self.nameTextField.mas_bottom).with.offset(45);
        make.width.equalTo(@279);
        make.left.right.equalTo(self.contentView);
    }];
    
    self.getStartedButton = getStartedButton;
}

#pragma mark - Binding

- (void)bindConfirmCommand
{
    self.confirmCommand =
    [[RACCommand alloc] initWithEnabled:[self textFieldSignal] signalBlock:^RACSignal *(id input)
     {
         [[NSUserDefaults standardUserDefaults] setObject:self.nameTextField.text forKey:@"email"];
         [[NSUserDefaults standardUserDefaults] synchronize];
         return [RACSignal return:@1];
     }];
    
    [self.confirmCommand displayProgressHUDWhileExecutingInView:self.view];
    
    [self.confirmCommand displayErrorInAlertViewWithTitle:NSLocalizedString(@"Error", nil)];
    
    [self.confirmCommand subscribeAllNext:^{
        [self dismissViewControllerAnimated:YES completion:nil];
    }];
}

- (void)bindButton
{
    self.getStartedButton.rac_command = self.confirmCommand;
    
}

- (RACSignal *)textFieldSignal
{
    return [self.nameTextField.rac_textSignal map:^id(NSString *text) {
        return @((text.length > 0));
    }];
}

#pragma mark - Actions

- (void)dismssKeyboard
{
    [self.view endEditing:YES];
}

#pragma mark - UITextField Delegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self.confirmCommand execute:textField];
    return (self.nameTextField.text.length > 0);
}

@end
