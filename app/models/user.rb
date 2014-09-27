class User < ActiveRecord::Base
  MAX_USERNAME_LENGTH = 128
  MAX_PASSWORD_LENGTH = 128
  validates :user, presence: true
  # validates :user, uniqueness: true
  validates_uniqueness_of :user, message: "-2"
  validates_length_of :user, :maximum => MAX_USERNAME_LENGTH, message: "-3"
  validates_length_of :password, :maximum => MAX_PASSWORD_LENGTH, message: "-4"

  def self.authenticate(username, password)
    user = find_by_user(username)
    if user && user.password == password
      user
    else
      # user.errors.add '-1'
      # validates :password do |record, value|
      #   record.errors.add '-2' if value.to_s != password
      # end
      # validates :password, if: ":password != password", message: "-2"
      if user
        user.errors.add(:password, '-1')
      end
      nil
    end
  end
end