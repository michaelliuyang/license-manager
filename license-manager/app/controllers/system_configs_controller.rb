class SystemConfigsController < ApplicationController
  
  before_filter :validate_is_admin,:except => [:exit]
  
  # GET /system_configs
  # GET /system_configs.json
  def index
    @system_configs = SystemConfig.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render :json => @system_configs }
    end
  end

  # GET /system_configs/1
  # GET /system_configs/1.json
  def show
    @system_config = SystemConfig.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render :json => @system_config }
    end
  end

  # GET /system_configs/new
  # GET /system_configs/new.json
  def new
    @system_config = SystemConfig.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render :json => @system_config }
    end
  end

  # GET /system_configs/1/edit
  def edit
    @system_config = SystemConfig.find(params[:id])
  end

  # POST /system_configs
  # POST /system_configs.json
  def create
    @system_config = SystemConfig.new(params[:system_config])

    respond_to do |format|
      if @system_config.save
        session[:license_path] = @system_config.license_path
        format.html { redirect_to @system_config, :notice => I18n.t('system_config.create_success') }
        format.json { render :json => @system_config, :status => :created, :location => @system_config }
      else
        format.html { render :action => "new" }
        format.json { render :json => @system_config.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /system_configs/1
  # PUT /system_configs/1.json
  def update
    @system_config = SystemConfig.find(params[:id])

    respond_to do |format|
      if @system_config.update_attributes(params[:system_config])
        session[:license_path] = @system_config.license_path
        format.html { redirect_to @system_config, :notice => I18n.t('system_config.create_success') }
        format.json { head :no_content }
      else
        format.html { render :action => "edit" }
        format.json { render :json => @system_config.errors, :status=> :unprocessable_entity }
      end
    end
  end

  # DELETE /system_configs/1
  # DELETE /system_configs/1.json
  def destroy
    @system_config = SystemConfig.find(params[:id])
    @system_config.destroy

    respond_to do |format|
      format.html { redirect_to system_configs_url }
      format.json { head :no_content }
    end
  end
  
  def test_path
    file_path = params[:path]
    @path_array = SystemConfig.find_license_folder file_path
    respond_to do |format|
      format.html # new.html.erb
      format.text { render :text => format_file_path }
    end
  end
  
  private
  
  def format_file_path
    result = ''
    @path_array.each do |path|
      result = result + path.to_s + '<br/>'
    end
    result == '' ? I18n.t('system_config.path_has_any_versions') : result
  end
  
end
