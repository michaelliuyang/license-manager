class Product < ActiveRecord::Base
  
  paginates_per 10
  
  attr_accessible :name, :value, :is_must
  
  # has_and_belongs_to_many :license
  has_many :license_productships,:dependent => :destroy
  has_many :license, :through => :license_productships
  
  def self.find_by_ids(ids)
    products = []
    ids.each do |id|
      products << Product.find(id)
    end
    products
  end
  
  def self.mutiple_delete(ids)
    begin
      Product.transaction do
        ids.each do |id|
          product = Product.find id
          product.destroy
          return true
        end
      end
    rescue => ex
      Rails.logger.error ex
      return false
    end
  end
  
end
