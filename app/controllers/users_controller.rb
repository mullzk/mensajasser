class UsersController < ApplicationController
  before_action :authorize, :except => :login

  before_action :set_user, only: [:show, :edit, :update, :destroy]



  def login
    if request.post?
      user = User.authenticate(params[:name], params[:password])
      if user
        session[:user_id] = user.id
        redirect_to :controller => "rounds", :action => "new"
      else
        flash[:notice] = "Ungültige user/passwort Kombination"
        puts flash[:notice]
      end
    end
  end

  def logout
    session[:user_id] = nil
    session[:user_is_admin] = nil
    flash[:notice] = "Logged out"
    redirect_to :controller => :ranking, :action => :year
  end

  def change_own_password
    
    # TODO #BUG: We can change the password even if the old one is wrong. 
    
    @user = User.find_by_id(session[:user_id])    
    if request.post?
      user = User.authenticate(@user.username, params[:old_password])
      if user
        if @user.update_attributes(params[:user])
          flash[:notice] = 'Password geändert'
          redirect_to :controller => "rounds", :action => "new" 
        end
      else
        flash[:notice] = "Altes Passwort ist ungültig"
      end
    end
  end






  # GET /users
  def index
    @users = User.all
  end

  # GET /users/1
  def show
  end

  # GET /users/new
  def new
    @user = User.new
  end

  # GET /users/1/edit
  def edit
  end

  # POST /users
  def create
    @user = User.new(user_params)

    if @user.save
      redirect_to @user, notice: 'User was successfully created.'
    else
      render :new
    end
  end

  # PATCH/PUT /users/1
  def update
    if @user.update(user_params)
      redirect_to @user, notice: 'User was successfully updated.'
    else
      render :edit
    end
  end

  # DELETE /users/1
  def destroy
    @user.destroy
    redirect_to users_url, notice: 'User was successfully destroyed.'
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_user
      @user = User.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def user_params
      params.fetch(:user, {}).permit(:username, :password)
    end
end
