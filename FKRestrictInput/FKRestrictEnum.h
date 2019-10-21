//
//  FKRestrict.h
//  输入限制测试
//
//  Created by norld on 2019/10/21.
//  Copyright © 2019 norld. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, RestrictType) {
    RestrictTypeNone            = 0,        // 没有限制, 只在单独设置时有效
    RestrictTypeUpperLetter     = 1 << 0,   // 只可输入大写字母, 字符集为 A-Z
    RestrictTypeLowerLetter     = 1 << 1,   // 只可输入小写字母, 字符集为 a-z
    RestrictTypeDigital         = 1 << 2,   // 只可输入数字, 字符集为 0-9
    RestrictTypeEnglishSymbol   = 1 << 3,   // 只可输入英文符号, 字符集为 ~!@#$%^&*()_+{}|:\"\\[];',./-=`
    RestrictTypeWhitespace      = 1 << 4,   // 只可输入空白字符
    RestrictTypeNewLine         = 1 << 5,   // 只可输入换行字符
    RestrictTypeControl         = 1 << 6,   // 只可输入控制字符
    RestrictTypeOther           = 1 << 9    // 另外限制的字符, 使用 otherRestrictString 属性设置, 混合使用时不可添加已在其他限制枚举中的字符, 否则会发生预料之外的结果
};
