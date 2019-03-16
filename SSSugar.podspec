Pod::Spec.new do |spec|
  spec.name         = "SSSugar"
  spec.version      = "1.0.0"
  spec.summary      = "Language sugar, extensions and classes that will make developmenmt easier."
  spec.description  = "Language sugar, extensions and classes that will make developmenmt easier."
  spec.homepage     = "https://siva.pp.ua"
  spec.license      = "MIT"
  spec.author             = { "Stanislav Dmitriyev" => "mail@siava.pp.ua" }
  spec.platform     = :ios, "11.0"
  spec.source       = { :git => "https://SiavA@bitbucket.org/SiavA/sssugar.git", :tag => "1.0.1" }
  spec.source_files  = "SSSugar"
  spec.swift_version = "4.2" 
end
