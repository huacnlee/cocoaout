%W(command config version).each do |fname|
  require File.expand_path("../cocoaout/#{fname}", __FILE__)
end