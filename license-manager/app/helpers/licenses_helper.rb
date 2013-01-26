module LicensesHelper
  
  def local_check_type_for_select
    "<option value='NO_LOCAL_CHECK'>#{I18n.t('license.no_local_check')}</option>" +
    "<option value='IP_LOCAL_CHECK'>#{I18n.t('license.local_check_ip')}</option>" +
    "<option value='MAC_LOCAL_CHECK'>#{I18n.t('license.local_check_mac')}</option>"
  end
  
  def show_gjb_level(level)
    case level
    when '2'
      I18n.t 'license.gjb_level_2'
    when '3'
      I18n.t 'license.gjb_level_3'
    else
      ''
    end
  end
  
  def show_local_check_type(local_check_type)
    case local_check_type
    when 'NO_LOCAL_CHECK'
      I18n.t 'license.no_local_check'
    when 'IP_LOCAL_CHECK'
      I18n.t 'license.local_check_ip'
    when 'MAC_LOCAL_CHECK'
       I18n.t 'license.local_check_mac'
    else
      ''
    end
  end
  
end
