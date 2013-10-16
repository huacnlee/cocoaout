%W(command config).each do |fname|
  require File.expand_path("../cocoaout/#{fname}", __FILE__)
end