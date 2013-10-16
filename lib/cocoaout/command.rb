require "thor"

module Cocoaout
  class Command < Thor
    include Thor::Actions
    
    attr_accessor :config
    
    desc "init [APP_NAME]", "Init Cocoaout for current path"
    method_option :sdk, aliases: %W(-s), type: :string, default: 'macosx10.9',
                  desc: "SDK of current project for build (macosx10.8 macosx10.9 iphoneos7.0 iphoneos6.0)"
    method_option :bg_file_name, aliases: %W(-b), type: :string, default: 'dmg_background.tiff',
                  desc: "Background image file name with DMG"
    def init(app_name = nil)
      puts "Generate Cocoaoutfile."
      
      @sdk = options[:sdk]
      @app_name = app_name || Dir.pwd.split("/").last
      @bg_file_name = options[:bg_file_name]
      
      create_file "Cocoaoutfile" do
        src = "#{__dir__}/templates/Cocoaoutfile.erb"
        ERB.new(File.read src).result binding
      end
    end
    
    desc "deploy", "Build and release"
    method_option :configration_name, aliases: %W(-c), type: :string, default: 'Release',
                  desc: "use which \"Build Configuration\" to building. (Debug, Release or you custom name)"
    method_option :output, aliases: %W(-o), type: :string, 
                  desc: "DMG file output filename", required: true
    def deploy
      config_name = options[:configration_name] || "Release"
      self.build(config_name)
      self.create_dmg_with_release(options[:output])
    end
    
    desc "package", "Create dmg with builded app"
    method_option :output, aliases: %W(-o), type: :string,
                  desc: "DMG file output filename", required: true
    def package
      output = options[:output] || "~/Downloads/#{Cocoaout::config.app_name}.dmg"
      self.create_dmg_with_release(output)
    end
    
    desc "clean", "Clean old builds"
    def clean
      output = `#{Cocoaout::xcode_build} clean -scheme #{Cocoaout::config.app_name}`
      if not $?.success?
        puts output and exit 0
      else
        puts "Clean successed."
      end
    end
    
    protected
    def build(config_name)
      command = %(#{Cocoaout::xcode_build} build -scheme #{Cocoaout::config.app_name} archive \
      CONFIGURATION_BUILD_DIR='#{Cocoaout::build_dir}' \
      -configuration #{config_name} -sdk #{Cocoaout::config.sdk})
      exit 0 if not system command
    end
    
    def create_dmg_with_release(out_filename)
      app_name = Cocoaout::config.app_name
      src_dir = Dir.pwd
      dist_dir = Cocoaout::dist_dir
      temp_dir = Cocoaout::temp_dir
      dmg_background_file_name = Cocoaout::config.dmg_background_file_name
      build_dir = Cocoaout::build_dir
      
      print "Clean tmp."
      `rm -rf #{temp_dir}`
      `mkdir -p #{temp_dir}`
      puts "."
  
      print "Archive dSYM."
      `cp -r #{build_dir}/#{app_name}.app.dSYM #{temp_dir}/`
      print "."
      `cd #{temp_dir} && zip #{app_name}.dSYM.zip #{app_name}.app.dSYM/`
      puts "."
      `mv #{temp_dir}/#{app_name}.dSYM.zip ~/Downloads/#{app_name}.dSYM.zip`
  
      print "Building dmg."
      `mkdir -p #{dist_dir}/`
      `mkdir #{dist_dir}/.background`
      `ln -s /Applications #{dist_dir}/Applications`
      `cp -r #{src_dir}/#{dmg_background_file_name} #{dist_dir}/.background/`
      `cp -r #{build_dir}/#{app_name}.app #{dist_dir}/`
      print "."
  
      exit 0 unless system %(hdiutil create #{temp_dir}/#{app_name}-tmp.dmg -ov -volname "#{app_name}" \
                             -fs HFS+ -srcfolder "#{dist_dir}" -fsargs "-c c=64,a=16,e=16" -format UDRW)
    	attach_info = `hdiutil attach  -readwrite -noverify "#{temp_dir}/#{app_name}-tmp.dmg"`
      device_id = attach_info.match(/\/dev\/[\w\d]+/i)[0]
      disk_temp_name = attach_info.match(/\/Volumes\/([\w\d\s]+)/i)[1]
  
      print "Mounting dmg file for edit theme, please wait."
      3.times {
      	sleep 1
        print "."
      }
      puts ""
	
      config_dmg(disk_temp_name)
	
      exit 0 unless system %(hdiutil detach "#{device_id}")
      puts "Temp disk detached."
    	exit 0 unless system %(hdiutil convert #{temp_dir}/#{app_name}-tmp.dmg -format UDZO -imagekey zlib-level=9 -ov -o #{out_filename})
    end
    
    def config_dmg(disk_name)
      dmg_size = Cocoaout::config.dmg_size
      dmg_app_pos = Cocoaout::config.dmg_app_pos
      dmg_applications_pos = Cocoaout::config.dmg_applications_pos
      dmg_background_file_name = Cocoaout::config.dmg_background_file_name
      script = %(
    tell application "Finder"
    	tell disk "#{disk_name.strip}"
    		open
    		set current view of container window to icon view
    		set toolbar visible of container window to false
    		set statusbar visible of container window to false
    		set the bounds of container window to {#{dmg_size[:width]}, #{dmg_size[:height]}, 220, 200}
    		set viewOptions to the icon view options of container window
    		set arrangement of viewOptions to not arranged
    		set icon size of viewOptions to 72
    		set background picture of viewOptions to file ".background:#{dmg_background_file_name}"
    		set position of item "Xiami.app" of container window to {#{dmg_app_pos[:left]}, #{dmg_app_pos[:top]}}
    		set position of item "Applications" of container window to {#{dmg_applications_pos[:left]}, #{dmg_applications_pos[:top]}}
    		close
    		open
    		update without registering applications
    		delay 2
        close
    	end tell
    end tell
    )
      script.strip!
  
      exit 0 unless system %(osascript -e '#{script}')
      puts "DMG style changed."
    end
  end
end