class UsersController < ApplicationController

  def create
    p "*"*30
    p params
    p "*"*30

    respond_to do |format|
      format.html do
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
            redirect_to action: :sign_in
          end
        else
          # user = create_from_args(user, pw)
          user = User.new(:user => user, :password => pw, :count => 0)
          if user.save
            @user = user
            render 'index'
          else
            errCode = user.errors.first[1]
            render html: errCode
            # render 'index'
          end
        end
      end
      format.json do
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
    u = params[:u]
    user = u[:user]
    pw = u[:password]
    type = params[:commit]
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
    else
      # user = create_from_args(user, pw)
      respond_to do |format|
        format.html do
          user = User.new(:user => user, :password => pw, :count => 0)
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

  def show

  end

  def update

  end

end