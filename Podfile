platform :ios, '8.0'

target "TestTemplateProject" do    
    pod 'SDWebImage'
    pod 'ReactiveObjC'
    pod 'Masonry'
    pod 'IQKeyboardManager'
end

post_install do |installer|
    project = installer.pods_project
    project.targets.each do |target|
        target.build_configurations.each do |config|
            config.build_settings['CLANG_WARN_STRICT_PROTOTYPES'] = 'NO'
            config.build_settings['CLANG_WARN_DOCUMENTATION_COMMENTS'] = 'NO'
        end 
    end
end

