require_relative 'table'
require_relative 'user'


class Lunchroom
  attr_reader :users, :tables

  def initialize
    @users = []
    @tables = []
  end

  def self.load_users(channel_name)
    @users = User.get_user_list
  end

end