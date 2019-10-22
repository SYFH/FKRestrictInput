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
@property (nonatomic, assign, getter=isShouldChange) BOOL shouldChange;
@property (nonatomic, weak  , nullable) id<UITextViewDelegate> fakeDelegate;

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
- (BOOL)textViewShouldBeginEditing:(UITextView *)textView {
    if (self.fakeDelegate
        && [self.fakeDelegate conformsToProtocol:@protocol(UITextViewDelegate)]
        && [self.fakeDelegate respondsToSelector:@selector(textViewShouldBeginEditing:)]) {
        
        return [self.fakeDelegate textViewShouldBeginEditing:textView];
    } else {
        return YES;
    }
}

- (BOOL)textViewShouldEndEditing:(UITextView *)textView {
    if (self.fakeDelegate
        && [self.fakeDelegate conformsToProtocol:@protocol(UITextViewDelegate)]
        && [self.fakeDelegate respondsToSelector:@selector(textViewShouldEndEditing:)]) {
        
        return [self.fakeDelegate textViewShouldEndEditing:textView];
    } else {
        return YES;
    }
}

- (void)textViewDidBeginEditing:(UITextView *)textView {
    if (self.fakeDelegate
        && [self.fakeDelegate conformsToProtocol:@protocol(UITextViewDelegate)]
        && [self.fakeDelegate respondsToSelector:@selector(textViewDidBeginEditing:)]) {
        
        [self.fakeDelegate textViewDidBeginEditing:textView];
    }
}

- (void)textViewDidEndEditing:(UITextView *)textView {
    if (self.fakeDelegate
        && [self.fakeDelegate conformsToProtocol:@protocol(UITextViewDelegate)]
        && [self.fakeDelegate respondsToSelector:@selector(textViewDidEndEditing:)]) {
        
        [self.fakeDelegate textViewDidEndEditing:textView];
    }
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    
    if (self.fakeDelegate
        && [self.fakeDelegate conformsToProtocol:@protocol(UITextViewDelegate)]
        && [self.fakeDelegate respondsToSelector:@selector(textView:shouldChangeTextInRange:replacementText:)]) {
        
        self.shouldChange = [self.fakeDelegate textView:textView shouldChangeTextInRange:range replacementText:text];
    } else {
        self.shouldChange = YES;
    }
    
    self.shouldChangeRange = NSMakeRange(range.location, text.length);
    self.replacementText = text;
    self.start = range.location;
    
    return self.shouldChange;
}

- (void)textViewDidChange:(UITextView *)textView {
    if (self.fakeDelegate
        && [self.fakeDelegate conformsToProtocol:@protocol(UITextViewDelegate)]
        && [self.fakeDelegate respondsToSelector:@selector(textViewDidChange:)]) {
        
        [self.fakeDelegate textViewDidChange:textView];
    } else {
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
}

- (void)textViewDidChangeSelection:(UITextView *)textView {
    if (self.fakeDelegate
        && [self.fakeDelegate conformsToProtocol:@protocol(UITextViewDelegate)]
        && [self.fakeDelegate respondsToSelector:@selector(textViewDidChangeSelection:)]) {
        
        [self.fakeDelegate textViewDidChangeSelection:textView];
    }
}

- (BOOL)textView:(UITextView *)textView shouldInteractWithURL:(NSURL *)URL inRange:(NSRange)characterRange interaction:(UITextItemInteraction)interaction API_AVAILABLE(ios(10.0)) {
    
    if (self.fakeDelegate
        && [self.fakeDelegate conformsToProtocol:@protocol(UITextViewDelegate)]
        && [self.fakeDelegate respondsToSelector:@selector(textView:shouldInteractWithURL:inRange:interaction:)]) {
        
        return [self.fakeDelegate textView:textView shouldInteractWithURL:URL inRange:characterRange interaction:interaction];
    } else {
        return YES;
    }
}

- (BOOL)textView:(UITextView *)textView shouldInteractWithTextAttachment:(NSTextAttachment *)textAttachment inRange:(NSRange)characterRange interaction:(UITextItemInteraction)interaction API_AVAILABLE(ios(10.0)) {
    
    if (self.fakeDelegate
        && [self.fakeDelegate conformsToProtocol:@protocol(UITextViewDelegate)]
        && [self.fakeDelegate respondsToSelector:@selector(textView:shouldInteractWithTextAttachment:inRange:interaction:)]) {
        
        return [self.fakeDelegate textView:textView shouldInteractWithTextAttachment:textAttachment inRange:characterRange interaction:interaction];
    } else {
        return YES;
    }
}

#pragma mark - Getter/Setter
- (void)setDelegate:(id<UITextViewDelegate>)delegate {
    [super setDelegate:self];
    if (![delegate isEqual:self]) { self.fakeDelegate = delegate; }
}

@end
