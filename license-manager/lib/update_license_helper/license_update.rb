require 'rbconfig'
require 'rexml/document'

class LicenseUpdate
  
  def initialize(version,license,license_path)
    @license_path = license_path
    @version_path = "#{license_path}/#{version}"
    @license = license
    @license_home = "#{@version_path}/support_files"
  end
  
  def update_license
    template_file_name = generate_license_def_xml
    shell_str = "java -classpath \"#{format_jars}\" -Dlicense.home=\"#{@license_home}\" cn.ac.intec.license.generator.UpdateLicense -license #{@license_home}/license.dat -licenseDef #{@license_home}/#{template_file_name}"
    run_shell_script shell_str
    update_and_clean_license_file template_file_name
  end
  
  def self.has_license_jars?(version_path)
    Dir["#{version_path}/jars/*.jar"].size > 0
  end
  
  private
  
  def run_shell_script(shell_str)
    raise 'run shell error' if %x{#{shell_str}}.inspect == ''
  end
  
  def format_time(time)
    return '' unless time
    return time.strftime("%Y-%m-%d")
  end
  
  def get_license_def_xml
    xml = REXML::Document.new("<license/>")
    root_node = xml.root
    root_node << add_element('license-id','1')
    root_node << add_element('license-name','ISCAS')
    root_node << add_element('company',@license.custom_name)
    root_node << add_element('product',format_license_products(@license.products))
    root_node << add_element('version','5.0_RM')
    root_node << add_element('expiresDate',format_time(@license.expires_date))
    root_node << add_element('expires',@license.expires_date == nil ? 'false' : 'true')
    root_node << add_element('localCheckType',@license.local_check_type)
    root_node << add_element('localCheck',@license.local_check)
    root_node << add_element('clientName','user')
    root_node << add_element('numCopies','1')
    root_node.add_element 'userValue',{"name"=>"MAX_LICENSEUSER_NUMBER","value"=>@license.user_number}
    root_node.add_element 'userValue',{"name"=>"LICENSE_EXPIRETIME","value"=>"1200"}
    root_node.add_element 'userValue',{"name"=>"GJB_LEVEL","value"=>@license.gjb_level}
    xml
  end
  
  def add_element(name,value)
    element = REXML::Element.new name
    element.text = value
    element
  end
  
  def format_license_products(products)
    products_str = ''
    i = 0
    products.each do |product|
      products_str += (i == products.size - 1 ? product[:value] : product[:value] + ',')
      i = i + 1
    end
    products_str
  end
  
  def generate_license_def_xml
    xml = get_license_def_xml
    rand_str = Time.now.to_i
    file_name = "licensedef_temp_#{rand_str}.xml"
    write_file = File.new("#{@license_home}/#{file_name}",'w')
    write_file.puts '<?xml version="1.0" encoding="UTF-8"?>'
    xml.each do |line|
      write_file.puts line
    end
    write_file.close
    file_name
  end
  
  def format_jars
    jars_path = Dir["#{File.dirname(__FILE__)}/lib/*.jar"]
    Dir["#{@version_path}/jars/*.jar"].each do |jar|
      jars_path << jar
    end
    result = ''
    separator = (os == :windows ? ';' : ':')
    jars_path.each do |jar|
      result = result + jar.to_s + separator if jar
    end
    result
  end

  def os
    host_os = RbConfig::CONFIG['host_os']
    case host_os
    when /mswin|msys|mingw|cygwin|bccwin|wince|emc/
      :windows
    when /darwin|mac os/
      :macosx
    when /linux/
      :linux
    when /solaris|bsd/
      :unix
    else
      raise 'unknown plaform'
    end
  end
  
  def copy_files(target_path,files)
    FileUtils.mkdir_p target_path unless File.directory? target_path
    FileUtils.cp files,target_path
  end
  
  def update_and_clean_license_file(template_name)
    license_path = "#{@version_path}/license_files"
    new_license_file_name = "license_#{@license.id}.dat"
    FileUtils.rm_rf "#{@license_home}/#{template_name}"
    copy_files license_path,"#{@license_home}/license.dat"
    File.rename "#{license_path}/license.dat","#{license_path}/#{new_license_file_name}"
  end
end
