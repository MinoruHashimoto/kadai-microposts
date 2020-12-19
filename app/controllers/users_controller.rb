class UsersController < ApplicationController
  before_action :require_user_logged_in, only: [:index, :show, :edit, :followings, :followers, :likes]
  
  def index
    @users = User.order(id: :desc).page(params[:page]).per(25)
  end

  def show
    @user = User.find(params[:id])
    @microposts = @user.microposts.order(id: :desc).page(params[:page])
    counts(@user)
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)

    if @user.save
      flash[:success] = 'ユーザを登録しました。'
         session[:user_id] = @user.id
      redirect_to @user
    else
      flash.now[:danger] = 'ユーザの登録に失敗しました。'
      render :new
    end
  end
  
  def edit
  end
   
  def update
    @user = current_user
    if @user.update(user_params)
      flash[:success] = 'ユーザを更新しました。'
      redirect_to @user
    else
      flash.now[:danger] = 'ユーザは更新されませんでした。'
      render :edit
    end
  end
  
  def destroy
    current_user.destroy
    flash[:success] = 'ユーザは退会しました。'
    redirect_to signup_url
  end
  
  def followings
    @user = User.find(params[:id])
    @followings = @user.followings.page(params[:page])
    counts(@user)
  end
  
  def followers
    @user = User.find(params[:id])
    @followers = @user.followers.page(params[:page])
    counts(@user)
  end
  
  def likes
    @user = User.find(params[:id])
    @likes = @user.likes.page(params[:page])
    counts(@user)
  end

  private

  def user_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation)
  end
end
