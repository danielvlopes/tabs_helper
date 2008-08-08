require 'fileutils'
RAILS_ROOT = File.join(File.dirname(__FILE__), '..','..','..')

# Workaround a problem with script/plugin and http-based repos.
# See http://dev.rubyonrails.org/ticket/8189
Dir.chdir(Dir.getwd.sub(/vendor.*/, '')) do

##
## Copy over asset files (javascript/css/images) from the plugin directory to public/
##

def copy_files(source_path, destination_path, directory)
  source, destination = File.join(directory, source_path), File.join(RAILS_ROOT, destination_path)
  FileUtils.mkdir(destination) unless File.exist?(destination)
  FileUtils.cp_r(Dir.glob(source+'/*.*'), destination)
end

directory = File.dirname(__FILE__)

copy_files("/public", "/public", directory)

available_frontends = Dir[File.join(directory, 'frontends', '*')].collect { |d| File.basename d }
[ :stylesheets, :javascripts, :images].each do |asset_type|
  path = "/public/#{asset_type}/tabs"
  copy_files(path, path, directory)
  
  File.open(File.join(RAILS_ROOT, path, 'DO_NOT_EDIT'), 'w') do |f|
    f.puts "Any changes made to files in sub-folders will be lost."
    f.puts "See http://rafael.adm.br/rails_plugins/tabs_helper"
  end

  available_frontends.each do |frontend|
    source = "/frontends/#{frontend}/#{asset_type}/"
    destination = "/public/#{asset_type}/tabs/#{frontend}"
    copy_files(source, destination, directory)
  end
end

end