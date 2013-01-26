# encoding: utf-8
# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

unless User.exist('admin')
  user = User.new(:login_name=>'admin',:password=>'000000', :name=>'admin',:email=>'admin@nfschina.com',:is_admin=>true)
  User.save_user user
end
if SystemConfig.all.size < 1
  SystemConfig.create(:id => 1, :license_path => '', :site_name => 'QONE LICENSES管理平台')
end

INIT_PRODUCTS = [
  {:name=>'我的工作台',:value=>'home',:is_must=>true},
  {:name=>'项目管理',:value=>'pm',:is_must=>true},
  {:name=>'过程管理',:value=>'spa',:is_must=>true},
  {:name=>'文档中心',:value=>'doc',:is_must=>true},
  {:name=>'测量分析',:value=>'mt',:is_must=>true},
  {:name=>'高层视图',:value=>'hl',:is_must=>true},
  {:name=>'需求管理',:value=>'rm',:is_must=>false},
  {:name=>'配置管理',:value=>'scmt',:is_must=>false},
  {:name=>'系统管理',:value=>'sm',:is_must=>true}
]

INIT_PRODUCTS.each do |product|
  if Product.where(:name=> product[:name]).size < 1
    Product.create(:name => product[:name], :value => product[:value], :is_must => product[:is_must])
  end  
end