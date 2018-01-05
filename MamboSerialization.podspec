#
# Be sure to run `pod lib lint MamboSerialization.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
    s.name             = 'MamboSerialization'
    s.version          = '0.1.5'
    s.summary          = "MamboSerialization bring serialization, and base model class for your app."
    s.description      = "The MamboSerialization framework provides a base layer of functionality for serialization, and model classes are runtime inspectable for properties. The classes, protocols defined by MamboSerialization can be used throughout the iOS SDKs."
    
    s.homepage         = 'http://mambo.pe'
    s.license          = { :type => 'MIT', :text => 'Copyright 2017 Mambo' }
    s.author           = { 'Rone Loza' => 'rone.loza@mambo.pe' }
    s.source           = { :git => 'https://bitbucket.org/compec/MamboSerialization.git', :tag => s.version.to_s }
    
    s.ios.deployment_target = '8.0'
    
    s.default_subspecs= [
    "Core"
    #"Static"
    ]
    
    s.subspec "Core" do |ss|
        ss.vendored_frameworks = [
        "MamboSerialization/Frameworks/MamboSerialization-Release-iphoneuniversal/MamboSerialization.framework"
        ]
    end
    
    s.subspec 'Static' do |ss|

        ss.source_files = 'Framework/MamboSerialization/Classes/**/*.{h,m}'
        ss.public_header_files = 'Framework/MamboSerialization/Classes/**/*.h'
    end
end

