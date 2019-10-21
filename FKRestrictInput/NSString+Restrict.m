//
//  NSString+Restrict.m
//  输入限制测试
//
//  Created by norld on 2019/10/11.
//  Copyright © 2019 norld. All rights reserved.
//

#import "NSString+Restrict.h"

@implementation NSString (Restrict)

- (BOOL)rtf_isLettersString {
    NSRange range = [self rangeOfCharacterFromSet:[NSCharacterSet letterCharacterSet]];
    return self.length > 0 && range.length > 0;
}

- (NSString *)rtf_stayLettersString {
    return [[self componentsSeparatedByCharactersInSet:[NSCharacterSet letterCharacterSet].invertedSet] componentsJoinedByString:@""];
}

- (BOOL)rtf_isLowercaseString {
    NSRange range = [self rangeOfCharacterFromSet:[NSCharacterSet lowercaseLetterCharacterSet]];
    return self.length > 0 && range.length > 0;
}

- (NSString *)rtf_stayLowercaseString {
    return [[self componentsSeparatedByCharactersInSet:[NSCharacterSet lowercaseLetterCharacterSet].invertedSet] componentsJoinedByString:@""];
}

- (BOOL)rtf_isUppercaseString {
    NSRange range = [self rangeOfCharacterFromSet:[NSCharacterSet uppercaseLetterCharacterSet]];
    return self.length > 0 && range.length > 0;
}

- (NSString *)rtf_stayUppercaseString {
    return [[self componentsSeparatedByCharactersInSet:[NSCharacterSet uppercaseLetterCharacterSet].invertedSet] componentsJoinedByString:@""];
}

- (BOOL)rtf_isDigitalString {
    NSRange range = [self rangeOfCharacterFromSet:[NSCharacterSet characterSetWithCharactersInString:@"1234567890"]];
    return self.length > 0 && range.length > 0;
}

- (NSString *)rtf_stayDigitalString {
    return [[self componentsSeparatedByCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"1234567890"].invertedSet] componentsJoinedByString:@""];
}

- (BOOL)rtf_isSymbolString {
    NSRange range = [self rangeOfCharacterFromSet:[NSCharacterSet characterSetWithCharactersInString:@"~!@#$%^&*()_+{}|:\"\\[];',./-=`"]];
    return self.length > 0 && range.length > 0;
}

- (NSString *)rtf_staySymbolString {
    return [[self componentsSeparatedByCharactersInSet:[NSCharacterSet symbolCharacterSet].invertedSet] componentsJoinedByString:@""];
}

- (BOOL)rtf_isNewLineString {
    NSRange range = [self rangeOfCharacterFromSet:[NSCharacterSet newlineCharacterSet]];
    return self.length > 0 && range.length > 0;
}

- (NSString *)rtf_stayNewLineString {
    return [[self componentsSeparatedByCharactersInSet:[NSCharacterSet newlineCharacterSet].invertedSet] componentsJoinedByString:@""];
}

- (BOOL)rtf_isControlString {
    NSRange range = [self rangeOfCharacterFromSet:[NSCharacterSet controlCharacterSet]];
    return self.length > 0 && range.length > 0;
}

- (NSString *)rtf_stayControlString {
    return [[self componentsSeparatedByCharactersInSet:[NSCharacterSet controlCharacterSet].invertedSet] componentsJoinedByString:@""];
}

- (BOOL)rtf_isWhitespaceString {
    NSRange range = [self rangeOfCharacterFromSet:[NSCharacterSet whitespaceCharacterSet]];
    return self.length > 0 && range.length > 0;
}

- (NSString *)rtf_stayWhitespaceString {
    return [[self componentsSeparatedByCharactersInSet:[NSCharacterSet whitespaceCharacterSet].invertedSet] componentsJoinedByString:@""];
}

- (BOOL)rtf_isWhitespaceAndNewlineString {
    NSRange range = [self rangeOfCharacterFromSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    return self.length > 0 && range.length > 0;
}

- (NSString *)rtf_stayWhitespaceAndNewlineString {
    return [[self componentsSeparatedByCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet].invertedSet] componentsJoinedByString:@""];
}

- (BOOL)rtf_isOtherStringWithCharacters:(NSString *)characters {
    NSRange range = [self rangeOfCharacterFromSet:[NSCharacterSet characterSetWithCharactersInString:characters]];
    return self.length > 0 && range.length > 0;
}

- (NSString *)rtf_stayOtherStringWithCharacters:(NSString *)characters {
    return [[self componentsSeparatedByCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:characters].invertedSet] componentsJoinedByString:@""];
}

+ (NSString *)rtf_filterStringWithRestrictType:(RestrictType)restrictType
                               replacementText:(NSString *)replacementText
                           otherRestrictString:(NSString *)otherRestrictString
                                     maxLength:(NSUInteger)maxLength
                         isForceCaseConversion:(BOOL)isForceCaseConversion
                                  isStrictMode:(BOOL)isStrictMode {
    
    NSString *filterString = [NSString string];
    BOOL isIgnore = NO;
    
    // 遍历筛选限制外字符
    NSRange range = NSMakeRange(0, 0);
    for (int i = 0; i < replacementText.length; i += range.length) {
        @autoreleasepool {
            // 兼容 emoji 等字符
            range = [replacementText rangeOfComposedCharacterSequenceAtIndex:i];
            NSString *substring = [replacementText substringWithRange:range];
            
            // 大小写强制转换
            if (isForceCaseConversion && substring.rtf_isLettersString) {
                if ((restrictType & RestrictTypeLowerLetter)
                    && !(restrictType & RestrictTypeUpperLetter)) {
                    
                    filterString = [filterString stringByAppendingString:substring.lowercaseString];
                }
                
                else if ((restrictType & RestrictTypeUpperLetter)
                         && !(restrictType & RestrictTypeLowerLetter)) {
                    
                    filterString = [filterString stringByAppendingString:substring.uppercaseString];
                }
            }
            
            else if (substring.rtf_isLowercaseString && (restrictType & RestrictTypeLowerLetter)) {
                filterString = [filterString stringByAppendingString:substring];
            }
            
            else if (substring.rtf_isUppercaseString && (restrictType & RestrictTypeUpperLetter)) {
                filterString = [filterString stringByAppendingString:substring];
            }
            
            else if (substring.rtf_isDigitalString && (restrictType & RestrictTypeDigital)) {
                filterString = [filterString stringByAppendingString:substring];
            }
            
            else if (substring.rtf_isSymbolString && (restrictType & RestrictTypeEnglishSymbol)) {
                filterString = [filterString stringByAppendingString:substring];
            }
            
            else if (substring.rtf_isWhitespaceString && (restrictType & RestrictTypeWhitespace)) {
                filterString = [filterString stringByAppendingString:substring];
            }
            
            else if (substring.rtf_isNewLineString && (restrictType & RestrictTypeNewLine)) {
                filterString = [filterString stringByAppendingString:substring];
            }
            
            else if (substring.rtf_isControlString && (restrictType & RestrictTypeControl)) {
                filterString = [filterString stringByAppendingString:substring];
            }
            
            else if ([substring rtf_isOtherStringWithCharacters:otherRestrictString]
                && (restrictType & RestrictTypeOther)) {
                
                filterString = [filterString stringByAppendingString:substring];
            }
            
            else {
                // 在严格模式下, 一旦出现限制外字符则无视输入
                if (isStrictMode) {
                    isIgnore = YES;
                    break;
                }
            }
            
            // 避免过多的判断, 但严格模式下为全量判断
            if ((filterString.length >= maxLength) && !isStrictMode) {
                break;
            }
        }
    }
    
    if (isIgnore) {
        return @"";
    } else {
        return [NSString stringWithString:filterString];
    }
}

@end
