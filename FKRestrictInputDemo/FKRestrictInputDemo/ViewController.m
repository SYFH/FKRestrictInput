//
//  ViewController.m
//  FKRestrictInputDemo
//
//  Created by norld on 2019/10/21.
//  Copyright © 2019 norld. All rights reserved.
//

#import "ViewController.h"

#import "FKRestrictInput.h"

@interface ViewController ()<UITextFieldDelegate, UITextViewDelegate>

@property (nonatomic, strong) FKRestrictTextField *textField;
@property (nonatomic, strong) FKRestrictTextView *textView;

@property (nonatomic, strong) FKRestrictTextField *lengthTextField;
@property (nonatomic, strong) UIButton *lowerButton;
@property (nonatomic, assign) BOOL lower;
@property (nonatomic, strong) UIButton *upperButton;
@property (nonatomic, assign) BOOL upper;
@property (nonatomic, strong) UIButton *digitalButton;
@property (nonatomic, assign) BOOL digital;
@property (nonatomic, strong) UIButton *englishSymbolButton;
@property (nonatomic, assign) BOOL englishSymbol;
@property (nonatomic, strong) UIButton *whitespaceButton;
@property (nonatomic, assign) BOOL whitespace;
@property (nonatomic, strong) UIButton *lineButton;
@property (nonatomic, assign) BOOL line;
@property (nonatomic, strong) UIButton *controlButton;
@property (nonatomic, assign) BOOL control;
@property (nonatomic, strong) UIButton *forceCaseConversionButton;
@property (nonatomic, assign) BOOL forceCaseConversion;
@property (nonatomic, strong) UIButton *strictModeButton;
@property (nonatomic, assign) BOOL strictMode;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.textField.maxLength = 20;
    self.textField.placeholder = @"请输入";
    self.textField.layer.borderColor = [UIColor darkGrayColor].CGColor;
    self.textField.layer.borderWidth = 1;
    self.textField.layer.cornerRadius = 5;
    self.textField.clipsToBounds = YES;
    self.textField.returnKeyType = UIReturnKeyDone;
    self.textField.delegate = self;
    [self.view addSubview:self.textField];
    
    self.textView.maxLength = 20;
    self.textView.layer.borderColor = [UIColor darkGrayColor].CGColor;
    self.textView.layer.borderWidth = 1;
    self.textView.layer.cornerRadius = 5;
    self.textView.clipsToBounds = YES;
    self.textView.delegate = self;
    [self.view addSubview:self.textView];
    
    self.lengthTextField = [[FKRestrictTextField alloc] init];
    self.lengthTextField.placeholder = @"长度";
    self.lengthTextField.text = @"20";
    self.lengthTextField.maxLength = 4;
    self.lengthTextField.restrictType = RestrictTypeDigital;
    self.lengthTextField.strictMode = YES;
    self.lengthTextField.returnKeyType = UIReturnKeyDone;
    self.lengthTextField.textAlignment = NSTextAlignmentCenter;
    UILabel *lengtheRightLabel = [[UILabel alloc] init];
    lengtheRightLabel.text = @"位";
    self.lengthTextField.rightView = lengtheRightLabel;
    self.lengthTextField.rightViewMode = UITextFieldViewModeAlways;
    [lengtheRightLabel sizeToFit];
    self.lengthTextField.delegate = self;
    [self.view addSubview:self.lengthTextField];
    
    self.lowerButton = [[UIButton alloc] init];
    [self.lowerButton setTitle:@"小写" forState:UIControlStateNormal];
    [self.lowerButton setTitleColor:[UIColor systemBlueColor] forState:UIControlStateNormal];
    [self.lowerButton addTarget:self action:@selector(lowerDidTap:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.lowerButton];

    self.upperButton = [[UIButton alloc] init];
    [self.upperButton setTitle:@"大写" forState:UIControlStateNormal];
    [self.upperButton setTitleColor:[UIColor systemBlueColor] forState:UIControlStateNormal];
    [self.upperButton addTarget:self action:@selector(upperDidTap:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.upperButton];

    self.digitalButton = [[UIButton alloc] init];
    [self.digitalButton setTitle:@"数字" forState:UIControlStateNormal];
    [self.digitalButton setTitleColor:[UIColor systemBlueColor] forState:UIControlStateNormal];
    [self.digitalButton addTarget:self action:@selector(digitalDidTap:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.digitalButton];

    self.englishSymbolButton = [[UIButton alloc] init];
    [self.englishSymbolButton setTitle:@"英文符号" forState:UIControlStateNormal];
    [self.englishSymbolButton setTitleColor:[UIColor systemBlueColor] forState:UIControlStateNormal];
    [self.englishSymbolButton addTarget:self action:@selector(englishSymbolDidTap:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.englishSymbolButton];

    self.whitespaceButton = [[UIButton alloc] init];
    [self.whitespaceButton setTitle:@"空格" forState:UIControlStateNormal];
    [self.whitespaceButton setTitleColor:[UIColor systemBlueColor] forState:UIControlStateNormal];
    [self.whitespaceButton addTarget:self action:@selector(whitespaceDidTap:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.whitespaceButton];

    self.lineButton = [[UIButton alloc] init];
    [self.lineButton setTitle:@"换行" forState:UIControlStateNormal];
    [self.lineButton setTitleColor:[UIColor systemBlueColor] forState:UIControlStateNormal];
    [self.lineButton addTarget:self action:@selector(lineDidTap:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.lineButton];

    self.controlButton = [[UIButton alloc] init];
    [self.controlButton setTitle:@"控制符" forState:UIControlStateNormal];
    [self.controlButton setTitleColor:[UIColor systemBlueColor] forState:UIControlStateNormal];
    [self.controlButton addTarget:self action:@selector(controlDidTap:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.controlButton];

    self.forceCaseConversionButton = [[UIButton alloc] init];
    [self.forceCaseConversionButton setTitle:@"强制大小写转换" forState:UIControlStateNormal];
    [self.forceCaseConversionButton setTitleColor:[UIColor systemBlueColor] forState:UIControlStateNormal];
    [self.forceCaseConversionButton addTarget:self action:@selector(forceCaseConversionDidTap:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.forceCaseConversionButton];

    self.strictModeButton = [[UIButton alloc] init];
    [self.strictModeButton setTitle:@"严格模式" forState:UIControlStateNormal];
    [self.strictModeButton setTitleColor:[UIColor systemBlueColor] forState:UIControlStateNormal];
    [self.strictModeButton addTarget:self action:@selector(strictModeDidTap:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.strictModeButton];
}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    
    CGSize size = self.view.bounds.size;
    self.textField.frame = CGRectMake(12, 80, size.width - 24, 44);
    
    self.textView.frame = CGRectMake(12, CGRectGetMaxY(self.textField.frame) + 20, size.width - 24, 200);
    
    self.lengthTextField.frame = CGRectMake(12, CGRectGetMaxY(self.textView.frame) + 20, 70, 44);
    
    self.lowerButton.frame = CGRectMake(CGRectGetMaxX(self.lengthTextField.frame) + 12, CGRectGetMaxY(self.textView.frame) + 20, 60, 44);
    
    self.upperButton.frame = CGRectMake(CGRectGetMaxX(self.lowerButton.frame) + 12, CGRectGetMaxY(self.textView.frame) + 20, 60, 44);
    
    self.digitalButton.frame = CGRectMake(CGRectGetMaxX(self.upperButton.frame) + 12, CGRectGetMaxY(self.textView.frame) + 20, 60, 44);
    
    self.englishSymbolButton.frame = CGRectMake(12, CGRectGetMaxY(self.lengthTextField.frame) + 20, 80, 44);
    
    self.whitespaceButton.frame = CGRectMake(CGRectGetMaxX(self.englishSymbolButton.frame) + 12, CGRectGetMaxY(self.lengthTextField.frame) + 20, 60, 44);
    
    self.lineButton.frame = CGRectMake(CGRectGetMaxX(self.whitespaceButton.frame) + 12, CGRectGetMaxY(self.lengthTextField.frame) + 20, 60, 44);
    
    self.controlButton.frame = CGRectMake(CGRectGetMaxX(self.lineButton.frame) + 12, CGRectGetMaxY(self.lengthTextField.frame) + 20, 80, 44);
    
    self.forceCaseConversionButton.frame = CGRectMake(12, CGRectGetMaxY(self.englishSymbolButton.frame) + 12, 140, 44);
    
    self.strictModeButton.frame = CGRectMake(CGRectGetMaxX(self.forceCaseConversionButton.frame) + 12, CGRectGetMaxY(self.englishSymbolButton.frame) + 12, 80, 44);
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}


#pragma mark - Action
- (void)lowerDidTap:(UIButton *)sender {
    [self.view endEditing:YES];
    self.lower = !self.lower;
    if (self.lower) {
        self.textField.restrictType = self.textField.restrictType|RestrictTypeLowerLetter;
        self.textView.restrictType = self.textView.restrictType|RestrictTypeLowerLetter;
        [self selectedButton:sender];
    } else {
        self.textField.restrictType = self.textField.restrictType^RestrictTypeLowerLetter;
        self.textView.restrictType = self.textView.restrictType^RestrictTypeLowerLetter;
        [self deseletedButton:sender];
    }
}

- (void)upperDidTap:(UIButton *)sender {
    [self.view endEditing:YES];
    self.upper = !self.upper;
    if (self.upper) {
        self.textField.restrictType = self.textField.restrictType|RestrictTypeUpperLetter;
        self.textView.restrictType = self.textView.restrictType|RestrictTypeUpperLetter;
        [self selectedButton:sender];
    } else {
        self.textField.restrictType = self.textField.restrictType^RestrictTypeUpperLetter;
        self.textView.restrictType = self.textView.restrictType^RestrictTypeUpperLetter;
        [self deseletedButton:sender];
    }
}

- (void)digitalDidTap:(UIButton *)sender {
    [self.view endEditing:YES];
    self.digital = !self.digital;
    if (self.digital) {
        self.textField.restrictType = self.textField.restrictType|RestrictTypeDigital;
        self.textView.restrictType = self.textView.restrictType|RestrictTypeDigital;
        [self selectedButton:sender];
    } else {
        self.textField.restrictType = self.textField.restrictType^RestrictTypeDigital;
        self.textView.restrictType = self.textView.restrictType^RestrictTypeDigital;
        [self deseletedButton:sender];
    }
}

- (void)englishSymbolDidTap:(UIButton *)sender {
    [self.view endEditing:YES];
    self.englishSymbol = !self.englishSymbol;
    if (self.englishSymbol) {
        self.textField.restrictType = self.textField.restrictType|RestrictTypeEnglishSymbol;
        self.textView.restrictType = self.textView.restrictType|RestrictTypeEnglishSymbol;
        [self selectedButton:sender];
    } else {
        self.textField.restrictType = self.textField.restrictType^RestrictTypeEnglishSymbol;
        self.textView.restrictType = self.textView.restrictType^RestrictTypeEnglishSymbol;
        [self deseletedButton:sender];
    }
}

- (void)whitespaceDidTap:(UIButton *)sender {
    [self.view endEditing:YES];
    self.whitespace = !self.whitespace;
    if (self.whitespace) {
        self.textField.restrictType = self.textField.restrictType|RestrictTypeWhitespace;
        self.textView.restrictType = self.textView.restrictType|RestrictTypeWhitespace;
        [self selectedButton:sender];
    } else {
        self.textField.restrictType = self.textField.restrictType^RestrictTypeWhitespace;
        self.textView.restrictType = self.textView.restrictType^RestrictTypeWhitespace;
        [self deseletedButton:sender];
    }
}

- (void)lineDidTap:(UIButton *)sender {
    [self.view endEditing:YES];
    self.line = !self.line;
    if (self.line) {
        self.textField.restrictType = self.textField.restrictType|RestrictTypeNewLine;
        self.textView.restrictType = self.textView.restrictType|RestrictTypeNewLine;
        [self selectedButton:sender];
    } else {
        self.textField.restrictType = self.textField.restrictType^RestrictTypeNewLine;
        self.textView.restrictType = self.textView.restrictType^RestrictTypeNewLine;
        [self deseletedButton:sender];
    }
}

- (void)controlDidTap:(UIButton *)sender {
    [self.view endEditing:YES];
    self.control = !self.control;
    if (self.control) {
        self.textField.restrictType = self.textField.restrictType|RestrictTypeControl;
        self.textView.restrictType = self.textView.restrictType|RestrictTypeControl;
        [self selectedButton:sender];
    } else {
        self.textField.restrictType = self.textField.restrictType^RestrictTypeControl;
        self.textView.restrictType = self.textView.restrictType^RestrictTypeControl;
        [self deseletedButton:sender];
    }
}

- (void)forceCaseConversionDidTap:(UIButton *)sender {
    [self.view endEditing:YES];
    self.forceCaseConversion = !self.forceCaseConversion;
    if (self.forceCaseConversion) {
        self.textField.forceCaseConversion = YES;
        self.textView.forceCaseConversion = YES;
        [self selectedButton:sender];
    } else {
        self.textField.forceCaseConversion = NO;
        self.textView.forceCaseConversion = NO;
        [self deseletedButton:sender];
    }
}

- (void)strictModeDidTap:(UIButton *)sender {
    [self.view endEditing:YES];
    self.strictMode = !self.strictMode;
    if (self.strictMode) {
        self.textField.strictMode = YES;
        self.textView.strictMode = YES;
        [self selectedButton:sender];
    } else {
        self.textField.strictMode = NO;
        self.textView.strictMode = NO;
        [self deseletedButton:sender];
    }
}


#pragma mark - Private
- (void)selectedButton:(UIButton *)sender {
    sender.layer.borderColor = [UIColor systemBlueColor].CGColor;
    sender.layer.borderWidth = 1;
}

- (void)deseletedButton:(UIButton *)sender {
    sender.layer.borderColor = [UIColor whiteColor].CGColor;
    sender.layer.borderWidth = 0;
}


#pragma mark - UITextFieldDelegate
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
    NSLog(@"UITextField input: %@", string);
    return YES;
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField {
    if ([textField isEqual:self.lengthTextField]) {
        if (textField.text.length) {
            NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
            NSNumber *number = [numberFormatter numberFromString:self.lengthTextField.text];
            self.textField.maxLength = number.unsignedIntegerValue;
            self.textView.maxLength = number.unsignedIntegerValue;
        } else {
            textField.text = @"20";
            self.textField.maxLength = 20;
            self.textView.maxLength = 20;
        }
    }
    return YES;
}


#pragma mark - UITextViewDelegate
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    
    NSLog(@"UITextView input: %@", text);
    return YES;
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
