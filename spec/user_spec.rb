require 'spec_helper'
require 'rails_helper'

describe User do
    before :each do
      @user = User.new
    end

    # Models stuff
    it "should fail user blank" do
      @user.password = "tenletters"
      expect(@user.save).to_not be_valid
    end

    it "should fail username length" do
      @user.user = "tenletters"*20
      expect(@user.save).to_not be_valid
    end

    it "should fail password legnth" do
      @user.user = "james"
      @user.password = "tenletters"*20
      expect(@user.save).to_not be_valid
    end

    it "should fail user unique" do
      @user.user = "jack"
      @user.password = "asdf"
      @user.count = 3
      expect(@user.save).to be_valid
      @user = User.new
      @user.user = "jack"
      expect(@user.save).to_not be_valid
    end

    it "add user = has users" do
      @user.user = "Jack"
      @user.password = "pw"
      @user.count = 0
      expect(@user.save).to be_valid
      expect(User.count).to eq 1
    end

    # TESTAPI stuff
    it "reset = no users" do
      @user.user = "Jack"
      @user.password = "pw"
      @user.count = 0
      expect(@user.save).to be_valid
      User.TESTAPI_resetFixture
      expect(User.count).to eq 0
    end

    it "reset from empty = no users" do
      User.TESTAPI_resetFixture
      expect(User.count).to eq 0
    end

    # Authentication stuff
    it "wrong authentication = nil" do
      @user.user = "Jack"
      @user.password = "pw"
      @user.count = 0
      expect(@user.save).to be_valid
      u = User.authenticate("Jack", "wrongpw")
      expect(u).to eq nil
    end

    it "correct authentication = user" do
      @user.user = "Jack"
      @user.password = "pw"
      @user.count = 0
      expect(@user.save).to be_valid
      u = User.authenticate("Jack", "pw")
      expect(u).to eq @user
    end

    it "no username stored authentication = nil" do
      @user.user = "Jack"
      @user.password = "pw"
      @user.count = 0
      expect(@user.save).to be_valid
      u = User.authenticate("notJack", "pw")
      expect(u).to eq nil
    end
end