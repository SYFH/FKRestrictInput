//
//  NSString+Restrict.h
//  输入限制测试
//
//  Created by norld on 2019/10/11.
//  Copyright © 2019 norld. All rights reserved.
//


#import <Foundation/Foundation.h>

#import "FKRestrictEnum.h"

NS_ASSUME_NONNULL_BEGIN

@interface NSString (Restrict)

- (BOOL)rtf_isLettersString;
- (NSString *)rtf_stayLettersString;

- (BOOL)rtf_isLowercaseString;
- (NSString *)rtf_stayLowercaseString;

- (BOOL)rtf_isUppercaseString;
- (NSString *)rtf_stayUppercaseString;

- (BOOL)rtf_isDigitalString;
- (NSString *)rtf_stayDigitalString;

- (BOOL)rtf_isSymbolString;
- (NSString *)rtf_staySymbolString;

- (BOOL)rtf_isNewLineString;
- (NSString *)rtf_stayNewLineString;

- (BOOL)rtf_isControlString;
- (NSString *)rtf_stayControlString;

- (BOOL)rtf_isWhitespaceString;
- (NSString *)rtf_stayWhitespaceString;

- (BOOL)rtf_isWhitespaceAndNewlineString;
- (NSString *)rtf_stayWhitespaceAndNewlineString;

- (BOOL)rtf_isOtherStringWithCharacters:(NSString *)characters;
- (NSString *)rtf_stayOtherStringWithCharacters:(NSString *)characters;

+ (NSString *)rtf_filterStringWithRestrictType:(RestrictType)restrictType
                               replacementText:(NSString *)replacementText
                           otherRestrictString:(NSString *)otherRestrictString
                                     maxLength:(NSUInteger)maxLength
                         isForceCaseConversion:(BOOL)isForceCaseConversion
                                  isStrictMode:(BOOL)isStrictMode;

@end

NS_ASSUME_NONNULL_END
