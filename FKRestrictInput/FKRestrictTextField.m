//
//  FKRestrictTextField.m
//  输入限制测试
//
//  Created by norld on 2019/10/11.
//  Copyright © 2019 norld. All rights reserved.
//

#import "FKRestrictTextField.h"

#import "NSString+Restrict.h"

@interface FKRestrictTextField ()<UITextFieldDelegate>

@property (nonatomic, assign) NSUInteger start;
@property (nonatomic, assign) NSRange shouldChangeRange;
@property (nonatomic, strong) NSString *replacementString;
@property (nonatomic, assign, getter=isShouldChange) BOOL shouldChange;
@property (nonatomic, weak  , nullable) id<UITextFieldDelegate> fakeDelegate;

@end

@implementation FKRestrictTextField

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setup];
    }
    return self;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        [self setup];
    }
    return self;
}

- (void)setup {
    self.maxLength = UINTMAX_MAX;
    self.restrictType = RestrictTypeNone;
    self.otherRestrictString = @"";
    
    // 代理中, 在 marked 输入模式下, 输入的第一个字符无法触发 marked 标记, 故使用 target
    [self addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    self.delegate = self;
}


#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    if (self.fakeDelegate
        && [self.fakeDelegate conformsToProtocol:@protocol(UITextFieldDelegate)]
        && [self.fakeDelegate respondsToSelector:@selector(textFieldShouldBeginEditing:)]) {

        return [self.fakeDelegate textFieldShouldBeginEditing:textField];
    } else {
        return YES;
    }
}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    if (self.fakeDelegate
        && [self.fakeDelegate conformsToProtocol:@protocol(UITextFieldDelegate)]
        && [self.fakeDelegate respondsToSelector:@selector(textFieldDidBeginEditing:)]) {

        return [self.fakeDelegate textFieldDidBeginEditing:textField];
    }
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField {
    if (self.fakeDelegate
        && [self.fakeDelegate conformsToProtocol:@protocol(UITextFieldDelegate)]
        && [self.fakeDelegate respondsToSelector:@selector(textFieldShouldEndEditing:)]) {

        return [self.fakeDelegate textFieldShouldEndEditing:textField];
    } else {
        return YES;
    }
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    if (self.fakeDelegate
        && [self.fakeDelegate conformsToProtocol:@protocol(UITextFieldDelegate)]
        && [self.fakeDelegate respondsToSelector:@selector(textFieldDidEndEditing:)]) {

        return [self.fakeDelegate textFieldDidEndEditing:textField];
    }
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
    if (self.fakeDelegate
        && [self.fakeDelegate conformsToProtocol:@protocol(UITextFieldDelegate)]
        && [self.fakeDelegate respondsToSelector:@selector(textField:shouldChangeCharactersInRange:replacementString:)]) {

        self.shouldChange = [self.fakeDelegate textField:textField shouldChangeCharactersInRange:range replacementString:string];
    }
    else {
        self.shouldChange = YES;
    }
    
    self.shouldChangeRange = NSMakeRange(range.location, string.length);
    self.replacementString = string;
    self.start = range.location;
    
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField reason:(UITextFieldDidEndEditingReason)reason API_AVAILABLE(ios(10.0)) {
    
    if (self.fakeDelegate
        && [self.fakeDelegate conformsToProtocol:@protocol(UITextFieldDelegate)]
        && [self.fakeDelegate respondsToSelector:@selector(textFieldDidEndEditing:reason:)]) {

        [self.fakeDelegate textFieldDidEndEditing:textField reason:reason];
    }
}

- (void)textFieldDidChangeSelection:(UITextField *)textField API_AVAILABLE(ios(13.0), tvos(13.0)) {
    if (self.fakeDelegate
        && [self.fakeDelegate conformsToProtocol:@protocol(UITextFieldDelegate)]
        && [self.fakeDelegate respondsToSelector:@selector(textFieldDidChangeSelection:)]) {

        [self.fakeDelegate textFieldDidChangeSelection:textField];
    }
}

- (BOOL)textFieldShouldClear:(UITextField *)textField {
    if (self.fakeDelegate
        && [self.fakeDelegate conformsToProtocol:@protocol(UITextFieldDelegate)]
        && [self.fakeDelegate respondsToSelector:@selector(textFieldShouldClear:)]) {

        return [self.fakeDelegate textFieldShouldClear:textField];
    }
    else {
        return YES;
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if (self.fakeDelegate
        && [self.fakeDelegate conformsToProtocol:@protocol(UITextFieldDelegate)]
        && [self.fakeDelegate respondsToSelector:@selector(textFieldShouldReturn:)]) {

        return [self.fakeDelegate textFieldShouldReturn:textField];
    }
    else {
        if (textField.returnKeyType == UIReturnKeyDone) {
            [textField endEditing:YES];
        }
        return YES;
    }
}

- (void)textFieldDidChange:(UITextField *)textField {
    if (self.shouldChange == NO) { return; }
    
    if (textField.markedTextRange && !textField.markedTextRange.empty) {
        // 带有 marked 的输入, 如中文
    } else {
        // 只对有输入内容的操作进行限制
        // 删除, 剪切, marked 输入方式等都是没有输入长度的
        if (self.replacementString.length > 0 && self.restrictType > 0) {
            NSString *filterString = [NSString rtf_filterStringWithRestrictType:self.restrictType
                                                                replacementText:self.replacementString
                                                            otherRestrictString:self.otherRestrictString
                                                                      maxLength:self.maxLength
                                                          isForceCaseConversion:self.isForceCaseConversion
                                                                   isStrictMode:self.isStrictMode];
            textField.text = [textField.text stringByReplacingCharactersInRange:self.shouldChangeRange withString:filterString];
            
            // 根据内容的输入移动光标位置
            // dispatch_after 解决 textField.text 赋值后修改移动光标位置无法立即生效的问题
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                
                NSInteger offset = self.start + filterString.length;
                if (offset > self.maxLength) {
                    offset = self.maxLength;
                }
                UITextPosition *position = [textField positionFromPosition:textField.beginningOfDocument offset:offset];
                textField.selectedTextRange = [textField textRangeFromPosition:position toPosition:position];
            });
        }
        
        // 限制长度
        if (textField.text.length > self.maxLength) {
            textField.text = [textField.text substringToIndex:self.maxLength];
        }
        
        self.shouldChangeRange = NSMakeRange(NSNotFound, 0);
        self.replacementString = @"";
    }
}


#pragma mark - Getter/Setter
- (void)setDelegate:(id<UITextFieldDelegate>)delegate {
    [super setDelegate:self];
    if (![delegate isEqual:self]) { self.fakeDelegate = delegate; }
}

@end
