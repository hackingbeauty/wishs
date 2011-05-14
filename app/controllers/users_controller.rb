class UsersController < ApplicationController


  def show
    @user = User.find(params[:id])
  end

  def login
    @current_user = User.find
  end

  def new
    @title = "Sign up"
    @user = User.new
  end

  def edit
    @user = User.find(params[:id])
  end

   def create
    @user = User.new(params[:user])
    if @user.save
      sign_in @user
      flash[:success] = "Welcome to the Sample App!"
      redirect_to @user
    else
      @title = "Sign up"
      render 'new'
    end
  end

  def index
    @users = User.all
  end

end

