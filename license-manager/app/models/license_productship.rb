class LicenseProductship < ActiveRecord::Base
  attr_accessible :license, :product
  belongs_to :license
  belongs_to :product
  
  def self.save_by_license_and_products(license,products)
    flag = true
    products.each do |product|
      break unless flag
      ship = LicenseProductship.new :license=>license,:product=>product
      flag = ship.save
    end
    flag
  end
  
end