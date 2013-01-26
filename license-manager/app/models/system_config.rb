class SystemConfig < ActiveRecord::Base

  attr_accessible :license_path, :site_name
  
  def self.find_license_folder(file_path = nil)
    file_path = (file_path == nil ? SystemConfig.first[:license_path] : file_path)
    path_array = []
    if File.directory? file_path
      Dir.foreach(file_path) do |file|
        next if exclude? file
        s = File.join file_path,file
        if File.directory? s
        path_array << s
        end
      end
    end
    path_array
  end

  private

  def self.exclude?(file)
    exclude = ["^\\."]
    exclude.each do |s|
      if file.match(/#{s}/i)
      return true
      end
    end
    false
  end

end
