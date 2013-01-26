class License < ActiveRecord::Base
  paginates_per 10
  
  attr_accessible :custom_name, :expires_date, :local_check, :local_check_type, :memo, :publish_content, :publish_reason, :user_number, :version,:gjb_level
  
  has_many :license_productships,:dependent => :destroy
  has_many :products, :through => :license_productships
  
  def self.mutiple_delete(ids,license_path)
    begin
      License.transaction do
        ids.each do |id|
          license = License.find id
          license.destroy
          delete_license_file(id,license.version,license_path)
          return true
        end
      end
    rescue => ex
      Rails.logger.error ex
      return false
    end
  end
  
  def self.delete(id,license_path)
    begin
      License.transaction do
        license = License.find(id)
        license.destroy
        delete_license_file(id,license.version,license_path)
        return true
      end
    rescue => ex
      Rails.logger.error ex
      return false
    end
  end
  
  private
  
  def self.delete_license_file(id,version,license_path)
    file_path = "#{license_path}/#{version}/license_files/license_#{id}.dat"
    if File.exist? file_path
      FileUtils.rm_rf file_path
    else
      raise "not exist #{file_path}"
    end
  end
  
end