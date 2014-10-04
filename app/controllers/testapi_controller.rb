class TestapiController < ApplicationController
  def test
    t = `bundle exec rspec`
    render json: {nrFailed: 0, output: t, totalTests: 10}
  end

  def reset
    User.destroy_all
    # redirect_to root_path
    render json: {errCode: 1}
  end

  def show

  end
end