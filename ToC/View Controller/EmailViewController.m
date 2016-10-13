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
#import "KeyboardNotificationHelper.h"

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


@property (nonatomic, strong) KeyboardNotificationHelper *keyboardHelper;

@end

@implementation EmailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
