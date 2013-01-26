class UsersController < ApplicationController
  
  before_filter :validate_is_admin,:only => [:index,:new,:create,:lock_or_unlock,:exist,]
  
  # GET /users
  # GET /users.json
  def index
    @users = User.order(:name).page(params[:page])
    respond_to do |format|
      format.html # index.html.erb
      format.json { render :json=> @users }
    end
  end

  # GET /users/1
  # GET /users/1.json
  def show
    @user = User.find(params[:id])
    respond_to do |format|
      format.html # show.html.erb
      format.json { render :json => @user }
    end
  end

  # GET /users/new
  # GET /users/new.json
  def new
    @user = User.new
    respond_to do |format|
      format.html # new.html.erb
      format.json { render :json => @user }
    end
  end

  # GET /users/1/edit
  def edit
    if session[:user][:is_admin]
      @user = User.find(params[:id])
    else
      current_id = session[:user][:id]
      if current_id.to_i == params[:id].to_i
        @user = User.find(params[:id])
      else
        redirect_to licenses_url
      end
    end
  end

  # POST /users
  # POST /users.json
  def create
    @user = User.new();
    @user.login_name = params[:user][:login_name]
    @user.name = params[:user][:name]
    @user.password = params[:user][:password]
    @user.email = params[:user][:email]
    @user.is_admin = params[:user][:is_admin]
    @user.is_lock = params[:user][:is_lock]
    @create_success = nil
    respond_to do |format|
      if User.save_user @user
        format.html { redirect_to @user,:notice => t('user.create_success')}
        format.json { render :json => @user, :status=> :created, :location=> @user }
      else
        format.html { render :action => "new" }
        format.json { render :json => @user.errors, :status=> :unprocessable_entity }
      end
    end
  end

  # PUT /users/1
  # PUT /users/1.json
  def update
    @user = User.find(params[:id])
    respond_to do |format|
      if @user.update_attributes(params[:user])
        format.html { redirect_to @user, :notice => t('user.update_success') }
        format.json { head :no_content }
      else
        format.html { render :action => "edit" }
        format.json { render :json => @user.errors, :status=> :unprocessable_entity }
      end
    end
  end

  def login
    render :layout => 'login_layout' if request.get? && session[:user].nil?
    redirect_to_list session[:user] if request.get? && !session[:user].nil?
    validate_login if request.post?
  end

  def lock_or_unlock
    notice = ''
    if request.put?
      notice = User.lock(params[:id]) if params[:unlock_or_lock] == 'lock'
      notice = User.unlock(params[:id]) if params[:unlock_or_lock] == 'unlock'
    elsif request.post?
      ids = params[:ck_user_ids]
      ids.each do |id|
        notice = notice + User.lock(id) + "  " if params[:unlock_or_lock] == 'lock'
        notice = notice + User.unlock(id) + "  " if params[:unlock_or_lock] == 'unlock'
      end
    end
    format_lock_or_unlock(notice,params[:unlock_or_lock])
  end

  def search
    key_word = params[:search]
    sql = "select * from users where name like '%#{key_word}%' or login_name LIKE '%#{key_word}%'"
    @users = Kaminari.paginate_array(User.find_by_sql(sql)).page(params[:page])
    render :action=>'index'
  end

  def exist
    login_name = params[:login_name]
    render :text=> (User.exist(login_name) == nil ? 'no exist' : 'exist')
  end
  
  def update_password
    if request.post?
      respond_to do |format|
        @user = User.find(params[:id])
        if User.update_pwd @user,params[:new_pwd]
          format.html { redirect_to @user, :notice => t('user.update_pwd_success') }
        else
          format.html { render :action=> "update_password" }
        end
      end
    end
  end
  
  def validate_password
    result = User.validate_pwd session[:user],params[:current_pwd]
    render :text=> result
  end

  private

  def format_lock_or_unlock(notice,method)
    respond_to do |format|
      if notice != ''
        format.html { redirect_to users_url, :notice => t("user.#{method}ed_success",:login_name=>notice) }
        format.json { head :no_content }
      else
        format.html { render :action => "index" }
        format.json { render :json => user.errors, :status=> :unprocessable_entity }
      end
    end
  end

  def validate_login
    login_name = params[:login_name]
    password = params[:password]
    user = User.exist(login_name)
    @login_notice = nil
    if user == nil
      @login_notice = I18n.t('user.validate.user_no_exist')
      render_login_page
    elsif user.is_lock
      @login_notice = I18n.t('user.validate.user_is_lock')
      render_login_page
    elsif User.validate_pwd user,password
      session[:user] = user
      session[:license_path] = SystemConfig.first[:license_path]
      session[:system_name] = SystemConfig.first[:site_name]
      update_last_login_info user
      redirect_to_list user
    else
      @login_notice = I18n.t('user.validate.pwd_error')
      render_login_page
    end
  end

  def redirect_to_list(user)
    if user.is_admin
      redirect_to users_url
    else
      redirect_to licenses_url
    end
  end

  def update_last_login_info(user)
    User.update_last_login_ip user,request
    User.update_last_login_time user
  end

end
