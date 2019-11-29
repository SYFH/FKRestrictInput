Pod::Spec.new do |s|
    s.name                      = 'FKRestrictInput'
    s.version                   = '1.0.0'
    s.summary                   = 'FKRestrictInput'
    s.description  = <<-DESC
    对 UITextField 和 UITextView 进行输入限制, 支持限制大小写字母, 数字, 特殊符号等, 支持长度限制和强制大小字母转换
                   DESC
    s.homepage                  = 'https://github.com/SYFH/FKRestrictInput'
    s.license                   = 'MIT'
    s.author                    = { "norld" => "syfh@live.com" }
    s.source                    = { :git => 'https://github.com/SYFH/FKRestrictInput.git', :tag => "#{s.version}" }
    s.platform                  = :ios, "8.0"
    s.source_files              = 'FKRestrictInput/*.{h,m}'
    s.requires_arc              = true
    s.static_framework          = true

end