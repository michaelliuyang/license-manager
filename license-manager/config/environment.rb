# Load the rails application
require File.expand_path('../application', __FILE__)

# Initialize the rails application
LicenseManager::Application.initialize!

Time::DATE_FORMATS.merge!(
  :date => "%Y#{I18n.t('global.year')}%m#{I18n.t('global.month')}%d#{I18n.t('global.day')}"
)