//
//  ViewController.m
//  FKRestrictInputDemo
//
//  Created by norld on 2019/10/21.
//  Copyright © 2019 norld. All rights reserved.
//

#import "ViewController.h"

#import "FKRestrictInput.h"

@interface ViewController ()

@property (nonatomic, strong) FKRestrictTextField *textField;
@property (nonatomic, strong) FKRestrictTextView *textView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.textField.restrictType = RestrictTypeUpperLetter;
    self.textField.forceCaseConversion = YES;
    self.textField.maxLength = 12;
    self.textField.placeholder = @"请输入";
    [self.view addSubview:self.textField];
    
    self.textView.restrictType = RestrictTypeDigital|RestrictTypeNewLine|RestrictTypeWhitespace;
    self.textView.maxLength = 60;
    self.textView.layer.borderColor = [UIColor darkGrayColor].CGColor;
    self.textView.layer.borderWidth = 1;
    self.textView.layer.cornerRadius = 5;
    self.textView.clipsToBounds = YES;
    [self.view addSubview:self.textView];
}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    
    CGSize size = self.view.bounds.size;
    self.textField.frame = CGRectMake(12, 44, size.width - 24, 44);
    
    self.textView.frame = CGRectMake(12, CGRectGetMaxY(self.textField.frame), size.width - 24, 200);
}


#pragma mark - Getter/Setter
- (FKRestrictTextField *)textField {
    if (!_textField) {
        _textField = [[FKRestrictTextField alloc] init];
    }
    return _textField;
}

- (FKRestrictTextView *)textView {
    if (!_textView) {
        _textView = [[FKRestrictTextView alloc] init];
    }
    return _textView;
}

@end
