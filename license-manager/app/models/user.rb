require 'digest/md5'

class User < ActiveRecord::Base

  paginates_per 10
  
  attr_accessible :key,:email, :is_admin, :is_lock, :last_login_ip, :last_login_time, :login_name, :name,:password
  
  def self.exist(login_name)
    users = User.where(:login_name=>login_name)
    users.size > 0 ? users.first : nil
  end

  def self.update_last_login_ip(user,request)
    user.update_attributes({:last_login_ip=>request.remote_ip})
  end

  def self.update_last_login_time(user)
    time = Time.zone.now
    user.update_attributes({:last_login_time=>time})
  end

  def self.lock(id)
    user = User.find(id)
    user.update_attributes({:is_lock => true}) == true ? user.login_name : ''
  end

  def self.unlock(id)
    user = User.find(id)
    user.update_attributes({:is_lock => false}) == true ? user.login_name : ''
  end

  def self.password_is_right?(password)
    session[:user].password == password
  end
  
  def self.save_user(user)
    key = random_string 30
    user.key = key
    user.password = mix_password user.password,key
    user.save
  end
  
  def self.validate_pwd(user,input_password)
    user.password == mix_password(input_password,user.key)
  end
  
  def self.update_pwd(user,password)
    key = random_string 30
    new_pwd = mix_password password,key
    user.update_attributes({:password=>new_pwd,:key=>key})
  end
  
  private
  
  def self.md5(password)
    Digest::MD5.hexdigest(password)
  end
  
  def self.password_hash(password)
    Digest::SHA256.hexdigest(password)
  end
  
  def self.random_string(len)
    randstring = ""
    chars = ("a".."z").to_a + ("A".."Z").to_a + ("0".."9").to_a
    1.upto(len) { |i| randstring << chars[rand(chars.size-1)] }
    randstring
  end
  
  def self.mix_password(password,key)
    password_hash(md5(password.to_s).to_s + key.to_s)
  end

end
