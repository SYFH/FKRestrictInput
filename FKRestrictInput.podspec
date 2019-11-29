Pod::Spec.new do |s|
    s.name                      = 'FKRestrictInput'
    s.version                   = '0.0.1'
    s.summary                   = '对 UITextField 和 UITextView 进行输入限制'
    s.homepage                  = 'https://github.com/SYFH/FKRestrictInput'
    s.license                   = 'MIT'
    s.author                    = { "norld" => "syfh@live.com" }
    s.source                    = { :git => 'https://github.com/SYFH/FKRestrictInput.git', :tag => "#{s.version}" }
    s.platform                  = :ios, "8.0"
    s.source_files              = 'FKRestrictInput/*.{h,m}'
    s.requires_arc              = true
    s.static_framework          = true

end