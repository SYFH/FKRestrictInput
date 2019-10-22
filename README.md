### FKRestrictInput
对 UITextField 和 UITextView 进行输入限制, 支持限制大小写字母, 数字, 特殊符号等, 支持长度限制和强制大小字母转换.


### 基本使用
* restrictType    
进行限制输入的枚举, 默认 RestrictTypeNone, 可多选, 其中枚举 RestrictTypeOther 需要和 otherRestrictString 属性配合使用. 目前包含: `RestrictTypeNone`, `RestrictTypeUpperLetter`, `RestrictTypeLowerLetter`, `RestrictTypeDigital`, `RestrictTypeEnglishSymbol`, `RestrictTypeWhitespace`, `RestrictTypeNewLine`, `RestrictTypeControl`, `RestrictTypeOther`.

使用示例:
```
FKRestrictTextField *textView = [[FKRestrictTextField alloc] init];
textField.restrictType = RestrictTypeNone;    

FKRestrictTextView *textView = [[FKRestrictTextView alloc] init];
textView.restrictType = RestrictTypeUpperLetter | RestrictTypeLowerLetter | RestrictTypeDigital;
```
* maxLength    
进行长度限制, 默认 UINTMAX_MAX. 在过滤允许范围外字符也会根据此值来提前结束, 以提高性能.

* otherRestrictString    
在使用 RestrictTypeOther 枚举时才会处理, 用来处理枚举之外的限制字符. 注意, 最好不要填写已设置枚举中的字符, 否则会发生预料之外的结果

* forceCaseConversion    
进行强制大小写转换, 只在大写限制或小写限制只存在一个时生效, 即 restrictType 属性包含 RestrictTypeUpperLetter 或 RestrictTypeLowerLetter 其中之一, 其他枚举无影响.

* strictMode    
严格模式, 默认是否, 这种情况下, 对于允许外字符会进行过滤, 只留下允许范围内的字符, 而在严格模式下, 粘贴等操作不进行字符过滤, 只要其中包含限制以外的字符就忽略输入. 注意, 因为本模式会严格遍历所有字符, 所以在一次性粘贴超大量文本可能会造成卡顿.

### 效果展示(图片过大, 请注意流量)
![](https://github.com/SYFH/FKRestrictInput/blob/master/gif/1.gif)![](https://github.com/SYFH/FKRestrictInput/blob/master/gif/2.gif)

### 细节处理
* 关于再次设置代理    
目前已处理了代理被覆盖的问题, 可以在响应用户再次赋值的 delegate, 限制功能也不会受影响. 唯一受到的意外是在打印 FKRestrictTextField 或 FKRestrictTextView 的 delegate 时是自己本身, 而不是再次赋值的值.

* 关于中文等 marked 模式的输入    
UITextField 在输入 marked 模式的字符时, 第一个字符不会被识别为 marked, 只有在 target 的 UIControlEventEditingChanged 中才会正常处理, FKRestrictInput 已做好相关处理, 限制字符和限制长度都会忽略 marked, 包括但不限于中文简体, 中文繁体, 日文片假名, 日文平假名等输入法.

* 关于粘贴, 剪切等    
FKRestrictInput 已做好相关处理, 鉴于剪切, 删除操作没有输入任何字符, 所以会忽略忽略限制, 而粘贴, 则会根据是否严格模式来处理.
在非严格模式下, 粘贴大量文本会根据 maxLength 立即结束, 从而提高性能. 但在最坏的情况下, 即需要留下的字符过于偏后, 同样可能造成卡顿.