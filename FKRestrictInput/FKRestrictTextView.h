//
//  FKRestrictTextView.h
//  输入限制测试
//
//  Created by norld on 2019/10/21.
//  Copyright © 2019 norld. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "FKRestrictEnum.h"

NS_ASSUME_NONNULL_BEGIN

@interface FKRestrictTextView : UITextView

/// 另外的限制字符, 默认为空字符串, 不可添加已在限制枚举中的字符, 否则会发生预料之外的结果
@property (nonatomic, strong) NSString *otherRestrictString;

/// 最大长度, 默认为 UINTMAX_MAX
@property (nonatomic, assign) NSUInteger maxLength;

/// 字符串限制
@property (nonatomic, assign) RestrictType restrictType;

/// 强制大小写转换, 只在限制模式为单独大写或单独小写时生效
@property (nonatomic, assign, getter=isForceCaseConversion) BOOL forceCaseConversion;

/// 严格模式, 粘贴等操作不进行过滤, 只要包含限制以外的字符就无法输入. 在一次性输入大量文本可能会造成卡顿
@property (nonatomic, assign, getter=isStrictMode) BOOL strictMode;

@end

NS_ASSUME_NONNULL_END
