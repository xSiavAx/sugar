Pod::Spec.new do |spec|
  spec.name           = "SSSugar"
  spec.version        = "1.7.0.3"
  spec.summary        = "Language sugar, extensions and classes that will make developmenmt easier."
  spec.description    = "Include extensions for Controllers, CGRect, UIColor, DispatchQueue and many other useful staff."
  spec.homepage       = "https://siva.pp.ua"
  spec.license        = "MIT"
  spec.author         = { "Stanislav Dmitriyev" => "mail@siava.pp.ua" }
  spec.platforms      = { :ios => "10.3", :osx => "10.15" }
  spec.source         = { :git => "https://SiavA@bitbucket.org/SiavA/sssugar.git"}
  spec.source_files   = "SSSugar/**/*.swift"
  spec.swift_version  = "5.0" 
end
