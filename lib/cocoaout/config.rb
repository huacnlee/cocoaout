module Cocoaout
  class << self
    attr_accessor :config
    attr_accessor :xcode_build
    attr_accessor :temp_dir
    attr_accessor :dist_dir
    attr_accessor :build_dir
  end
  
  class Configuration
    attr_accessor :app_name, 
                  :sdk, 
                  :project,
                  :dmg_background_file_name, 
                  :dmg_size,
                  :dmg_app_pos,
                  :dmg_applications_pos
  end
  
  def self.configure(&block)
    self.config ||= Configuration.new
    yield(config)
    
    if self.config.project.match(/\.xcworkspace/)
      self.xcode_build = "xcodebuild -workspace #{self.config.project}"
    else
      self.xcode_build = "xcodebuild -project #{self.config.project}"
    end
    self.temp_dir = "/tmp/xcodebuild-make/#{self.config.app_name}"
    self.dist_dir = [self.temp_dir,"dist"].join("/")
    self.build_dir = [Dir.pwd,"build"].join("/")
  end
end