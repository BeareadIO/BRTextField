//
//  ViewController.m
//  BRTextField
//
//  Created by Archy on 2017/9/26.
//  Copyright © 2017年 bearead. All rights reserved.
//

#import "ViewController.h"
#import "BRTextField.h"

@interface ViewController ()<BRTextFieldDelegate>

@property (weak, nonatomic) IBOutlet BRTextField *defaultField;
@property (weak, nonatomic) IBOutlet BRTextField *closeField;
@property (weak, nonatomic) IBOutlet BRTextField *passwordField;
@property (weak, nonatomic) IBOutlet BRTextField *verifyField;
@property (weak, nonatomic) IBOutlet BRTextField *internationalField;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.defaultField.style = BRTextFieldStyleDefault;
    self.closeField.style = BRTextFieldStyleClose;
    self.passwordField.style = BRTextFieldStylePassword;
    self.verifyField.style = BRTextFieldStyleVerifyCode;
    self.internationalField.style = BRTextFieldStyleInternational;
    self.internationalField.delegate = self;
}

- (void)textFieldDidClickSupplyView:(BRTextField *)textField {
//    You Can do What you want to change textField UI
}

@end
