//
//  FKRestrictTextView.m
//  输入限制测试
//
//  Created by norld on 2019/10/21.
//  Copyright © 2019 norld. All rights reserved.
//

#import "FKRestrictTextView.h"

#import "NSString+Restrict.h"

@interface FKRestrictTextView ()<UITextViewDelegate>

@property (nonatomic, assign) NSUInteger start;
@property (nonatomic, assign) NSRange shouldChangeRange;
@property (nonatomic, strong) NSString *replacementText;

@end

@implementation FKRestrictTextView

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
    
    self.delegate = self;
}


#pragma mark - UITextViewDelegate
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    self.shouldChangeRange = NSMakeRange(range.location, text.length);
    self.replacementText = text;
    self.start = range.location;
    
    return YES;
}

- (void)textViewDidChange:(UITextView *)textView {
    if (textView.markedTextRange && !textView.markedTextRange.empty) {
        // 带有 marked 的输入, 如中文
    } else {
        // 只对有输入内容的操作进行限制
        // 删除, 剪切, marked 输入方式等都是没有输入长度的
        if (self.replacementText.length > 0 && self.restrictType > 0) {
            NSString *filterString = [NSString rtf_filterStringWithRestrictType:self.restrictType
                                                                replacementText:self.replacementText
                                                            otherRestrictString:self.otherRestrictString
                                                                      maxLength:self.maxLength
                                                          isForceCaseConversion:self.isForceCaseConversion
                                                                   isStrictMode:self.isStrictMode];
            textView.text = [textView.text stringByReplacingCharactersInRange:self.shouldChangeRange withString:filterString];
            
            // 根据内容的输入移动光标位置
            // dispatch_after 解决 textField.text 赋值后修改移动光标位置无法立即生效的问题
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                
                NSInteger offset = self.start + filterString.length;
                if (offset > self.maxLength) {
                    offset = self.maxLength;
                }
                UITextPosition *position = [textView positionFromPosition:textView.beginningOfDocument offset:offset];
                textView.selectedTextRange = [textView textRangeFromPosition:position toPosition:position];
            });
        }
        
        // 限制长度
        if (textView.text.length > self.maxLength) {
            textView.text = [textView.text substringToIndex:self.maxLength];
        }
        
        self.shouldChangeRange = NSMakeRange(NSNotFound, 0);
        self.replacementText = @"";
    }
}

@end
