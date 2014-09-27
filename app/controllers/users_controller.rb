class UsersController < ApplicationController

  def create
    p "*"*30
    p params
    p "*"*30

    u = params[:user]
    user = u[:user]
    pw = u[:password]
    type = params[:commit]
    if type == "signup"
      user = create_from_args(user, pw)
      respond_to do |format|
        format.html do
          if user.save
            @user = user
            render 'index'
          else
            errCode = user.errors.first[1]
            render html: errCode
            # render 'index'
          end
        end
        format.json do
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

      # @user = User.new
      # render 'index'
    end
    if type == "login"
      u = User.authenticate(user, pw)

      respond_to do |format|
        format.html do
          if u
            @user = u
            @user.count = @user.count+1
            @user.save
            render 'count'
          else
            redirect_to action: :sign_in
          end
        end
        format.json do
          if u
            @user = u
            @user.count = @user.count+1
            @user.save
            render json: {errCode: 1, count: @user.count}
          else
            render json: {errCode: -1}
          end
        end
      end
      if u
        @user = u
        @user.count = @user.count+1
        @user.save
        render 'count'
      else
        redirect_to action: :sign_in
      end
    end
  end

  def sign_in
    @user = User.new
    render 'index'
  end

  def login
    username = params[:user][:user]
    password = params[:user][:password]

    user = User.authenticate(username, password)

    if user
      @user = user
      @user.count = @user.count+1
      @user.save
      render 'count'
    else
      # @user = User.new
      redirect_to action: :sign_in
    end
  end

  def create_from_args(u, p)
    use = User.new(:user => u, :password => p, :count => 0)
    return use.save
  end

  def count
    @user.count = @user.count+1
    @user.save
    p "*"*30
    p params
    p "*"*30
    render 'count'
  end

  def show

  end

end