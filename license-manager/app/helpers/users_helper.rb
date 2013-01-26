module UsersHelper
    
  def show_validates_message(user,field_name)
    user.errors[field_name].first if user.errors[field_name].size > 0
  end
  
  def get_is_lock(is_lock)
    get_lock_or_admin_str(is_lock)
  end
  
  def get_is_admin(is_admin)
    get_lock_or_admin_str(is_admin)
  end
  
  def get_create_or_update_str(user)
    user.id == nil ? I18n.t('global.create') : I18n.t('global.update')
  end
  
  def lock_list
    "<option value='unlock'>#{I18n.t('user.unlock')}</option>"+
    "<option value='lock'>#{I18n.t('user.lock')}</option>"
  end
  
  private
  
  def get_lock_or_admin_str(flag)
    if flag
      I18n.t('global.y')
    else
      I18n.t('global.n') 
    end
  end
  
end
