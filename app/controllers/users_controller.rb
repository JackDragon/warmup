class UsersController < ApplicationController

  def create
    p "*"*30
    p params
    p "*"*30

    if params.has_key?(:u)
      u = params[:u]
      user = u[:user]
      pw = u[:password]
      type = params[:commit]
      if type == "login"
        u = User.authenticate(user, pw)
        if u
          @user = u
          @user.count = @user.count+1
          @user.save
          render 'count'
        else
          @user = User.new
          flash[:notice] = "-1: Bad password/username combination"
          redirect_to action: :sign_in
        end
      else
        # user = create_from_args(user, pw)
        user = User.new(:user => user, :password => pw, :count => 0)
        if user.save
          @user = User.new
          flash[:notice] = "1: Signed up successfully. You can now login."
          render 'index'
        else
          errCode = user.errors.first[1]
          # render html: errCode
          @user = User.new
          flash[:notice] = user.errors.full_messages.first
          render 'index'
        end
      end
    else
      user = params[:user]
      pw = params[:password]
      user = User.new(:user => user, :password => pw, :count => 0)
      if user.save
        render json: {errCode: 1, count: 0}
      else
        errCode = user.errors.first[1].to_s
        # p "ERRCODE: ", errCode
        if errCode == "can't be blank"
          render json: {errCode: -3}
        else
          errCode = errCode.to_i
          render json: {errCode: errCode}
        end
      end
    end
  end

  def sign_in
    @user = User.new
    render 'index'
  end

  def login
    if params.has_key?(:u)
      u = params[:u]
      username = u[:user]
      password = u[:password]

      user = User.authenticate(username, password)

      if user
        @user = user
        @user.count = @user.count+1
        @user.save
        render 'count'
      else
        # @user = User.new
        @user = User.new
        flash[:notice] = "-1: Bad password/username combination"
        redirect_to action: :sign_in
      end
    else
      username = params[:user]
      password = params[:password]

      user = User.authenticate(username, password)

      if user
        @user = user
        @user.count = @user.count+1
        @user.save
        render json: {errCode: 1, count: @user.count}
      else
        errCode = -1
        render json: {errCode: errCode}
      end
    end
  end

  # def create_from_args(u, p)
  #   use = User.new(:user => u, :password => p, :count => 0)
  #   if use.save
  #     return use
  #   return
  #   end
  # end

  def count
    @user.count = @user.count+1
    @user.save
    p "*"*30
    p params
    p "*"*30
    render 'count'
  end

  def make
    u = User.new
    if params.has_key?(:user)
      u.user = params[:user]
    end
    if params.has_key?(:password)
      u.user = params[:password]
    end
    if params.has_key?(:count)
      u.user = params[:count]
    else
      u.count = 0
    end
    return u
  end

  def show

  end

  def update

  end

end