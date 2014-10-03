require 'spec_helper'
require 'rails_helper'

describe User do
    # before :each do
    # end

    it "should not fail user save" do
      u = User.new(user: "jack", password:"j", count:1)
      expect(u.save).to be_valid
    end
    
    # Models stuff
    it "should fail user blank" do
      testuser = User.new(user: "", password: "tenletters")
      # testuser.password = "tenletters"
      expect(testuser.save).to_not be_valid
    end

    it "should fail username length" do
      testuser = User.new(user: "tenletters"*20)
      expect(testuser.save).to_not be_valid
    end

    it "should fail password legnth" do
      testuser = User.new(user:"james", password:"tenletters"*20)
      expect(testuser.save).to_not be_valid
    end

    it "should fail user unique" do
      testuser = User.new(user: "jack", password: "asdf", count: 3)
      expect(testuser.save).to be_valid
      testuser = User.new(user: "jack")
      expect(testuser.save).to_not be_valid
    end

    it "add user = has users" do
      testuser = User.new(user: "Jack", password: "pw", count: 0)
      expect(testuser.save).to be_valid
      expect(User.count).to eq 1
    end

    # TESTAPI stuff
    it "reset = no users" do
      testuser = User.new(user: "Jack", password: "pw")
      expect(testuser.save).to be_valid
      User.TESTAPI_resetFixture
      expect(User.count).to eq 0
    end

    it "reset from empty = no users" do
      User.TESTAPI_resetFixture
      expect(User.count).to eq 0
    end

    # Authentication stuff
    it "wrong authentication = nil" do
      testuser = User.new(user: "Jack", password: "pw", count: 0)
      expect(testuser.save).to be_valid
      u = User.authenticate(user: "Jack", password: "wrongpw")
      expect(u).to eq nil
    end

    it "correct authentication = user" do
      testuser = User.new(user: "Jack", password: "pw", count: 0)
      expect(testuser.save).to be_valid
      u = User.authenticate(user: "Jack", password: "pw")
      expect(u).to eq testuser
    end

    it "no username stored authentication = nil" do
      testuser = User.new(user: "Jack", password: "pw", count: 0)
      expect(testuser.save).to be_valid
      u = User.authenticate(user: "notJack", password: "pw")
      expect(u).to eq nil
    end
end