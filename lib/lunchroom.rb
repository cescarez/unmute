require_relative 'table'
require_relative 'user'

MEMBERS_LIST_URL = "https://slack.com/api/conversations.members"
CONVERSATIONS_LIST_URL = "https://slack.com/api/conversations.list"
USER_CONVERSATIONS_URL = "https://slack.com/api/users.conversations"

class Lunchroom
  attr_reader :users, :tables, :channel_id

  def initialize
    @channel_id = ""
    @channel_name = ""
    @users = []
    @tables = []
  end

  def self.load_users
    @users = list_users(CHANNEL_NAME)
  end

  private

 # def get_app_channel
 #    query = {token: get_slack_token}
 #    bot_conversations = Helper.check_response(HTTParty.get(USER_CONVERSATIONS_URL, query: query)
 #    bot_conversations = bot_conversations["channels"]
 #
 #    if bot_conversations.length > 1
 #      #todo: add option to enter custom channel name (from bot_conversations.map { |conversation| conversation["name"]), with input checking
 #      raise ArgumentError, "The unmute App has been added to more than one channel in this Workspace. Please install unmute App on only one channel. "
 #    else
 #      @channel_id = bot_conversations.first["id"].freeze
 #      @channel_name = bot_conversations.first["name"].freeze
 #    end
 #  end

  def self.get_channel_id(channel_name)
    query = {token: get_slack_token}
    response = Helper.check_response(HTTParty.get(CONVERSATIONS_LIST_URL, query: {token: get_slack_token})
    found_channel = response.find { |channel| channel["name"].downcase == channel_name.downcase }
    @channel_id = found_channel["id"].freeze
  end

  def self.list_users(channel_name)
    query = {
        token: get_slack_token,
        channel: get_channel_id(channel_name)
    }
    response = Helper.check_response(HTTParty.get(MEMBERS_LIST_URL, query: query))

    return response.map do |user|
      User.new(slack_id: user["id"], name: user["name"], real_name: user["real_name"], is_active: true, group_size: :pair, is_confirmed: false)
    end

    #TODO: bot to send welcome message and set is_active upon response, and change :group_size to user selection --- webhook?

  end


  def self.get_slack_token
    # return ENV["SLACK_TOKEN"]
    return ENV["TEST_TOKEN"]
  end

end