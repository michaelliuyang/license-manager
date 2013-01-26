require 'update_license_helper/license_update'

class LicensesController < ApplicationController
  # GET /licenses
  # GET /licenses.json
  def index
    current_user = session[:user]
    if current_user.is_admin
      @licenses = License.order("created_at DESC").page(params[:page])
    else
      @licenses = License.where(:applicant=>current_user.name).order("created_at DESC").page(params[:page])
    end
    respond_to do |format|
      format.html # index.html.erb
      format.json { render :json => @licenses }
    end
  end

  # GET /licenses/1
  # GET /licenses/1.json
  def show
    @license = License.find(params[:id])
    @products = Product.all
    respond_to do |format|
      format.html # show.html.erb
      format.json { render :json => @license }
    end
  end

  # GET /licenses/new
  # GET /licenses/new.json
  def new
    @license = License.new
    @products = Product.all
    @versions = format_version SystemConfig.first[:license_path]
    respond_to do |format|
      format.html # new.html.erb
      format.json { render :json => @license }
    end
  end

  # GET /licenses/1/edit
  def edit
    @license = License.find(params[:id])
    @products = Product.all
  end

  # POST /licenses
  # POST /licenses.json
  def create
    @license = License.new(params[:license])
    @license.applicant = session[:user][:name]
    products = Product.find_by_ids(params[:ck_product_ids])
    begin
      License.transaction do
        if (@license.save) && (LicenseProductship.save_by_license_and_products @license,products)
          generator_license_file @license
          redirect_to @license, :notice => t('license.create_success')
        else
          redirect_to :back ,:notice => t('license.create_failed')
        end
      end
    rescue => ex
      Rails.logger.error ex
      redirect_to :back ,:notice => t('license.create_failed')
    end
  end

  # PUT /licenses/1
  # PUT /licenses/1.json
  def update
    @license = License.find(params[:id])

    respond_to do |format|
      if @license.update_attributes(params[:license])
        format.html { redirect_to @license, :notice => t('license.update_success') }
        format.json { head :no_content }
      else
        format.html { render :action => "edit" }
        format.json { render :json => @license.errors, :status=> :unprocessable_entity }
      end
    end
  end

  # DELETE /licenses/1
  # DELETE /licenses/1.json
  def destroy
    flash[:error] = I18n.t('license.delete_failed') unless License.delete params[:id],session[:license_path]
    redirect_to licenses_url
  end

  def search
    current_user = session[:user]
    key_word = params[:search]
    sql = ''
    if current_user.is_admin
      sql = "select * from licenses where custom_name like '%#{key_word}%' or applicant LIKE '%#{key_word}%'"
    else
      sql = "select * from licenses where applicant = '#{current_user.name}' and custom_name like '%#{key_word}%'"
    end
    @licenses = Kaminari.paginate_array(License.find_by_sql(sql)).page(params[:page])
    render :action=>'index'
  end

  def download
    license = License.find(params[:id])
    file_name = "license_#{license.id}.dat"
    license_path = "#{session[:license_path]}/#{license.version}/license_files"
    io = File.open("#{license_path}/#{file_name}")
    io.binmode
    send_data(io.read,:filename=>'license.dat',:disposition=>'attachment')
    io.close
  end

  def exist_jars
    version_path = "#{session[:license_path]}/#{params[:version]}"
    render :text=> LicenseUpdate.has_license_jars?(version_path)
  end
  
  def mutiple_delete
    ids = params[:ck_license_ids]
    flash[:error] = I18n.t('license.delete_failed') unless License.mutiple_delete ids,session[:license_path]
    redirect_to licenses_url
  end
  
  private

  def format_version(version_root_path)
    license_paths = SystemConfig.find_license_folder
    versions = []
    license_paths.each do |path|
      version = path.delete(version_root_path)
      versions << version
    end
    versions
  end

  def generator_license_file(license)
    license_update = LicenseUpdate.new license.version,license,session[:license_path]
    license_update.update_license
  end

end
