require_relative 'table'
require_relative 'user'

USERS_LIST_URL = "https://slack.com/api/users.list"
MEMBERS_LIST_URL = "https://slack.com/api/conversations.members"
CONVERSATIONS_LIST_URL = "https://slack.com/api/conversations.list"
USER_CONVERSATIONS_URL = "https://slack.com/api/users.conversations"

class Lunchroom
  attr_reader :users, :tables, :channel_id, :unmute_bot, :channel_name

  def initialize
    @channel_id = ""
    @channel_name = ""
    @users = []
    @tables = []
    @unmute_bot = nil
  end

 def get_app_channel
    query = {token: self.class.get_slack_token}
    bot_conversations = Helper.check_response(HTTParty.get(USER_CONVERSATIONS_URL, query: query))
    bot_conversations = bot_conversations["channels"]
    bot_conversation_names = bot_conversations.map { |channel| channel["name"] }

    if bot_conversation_names.length > 1
      puts "The unmute App has been added to more than one channel #{bot_conversation_names} in this Workspace."
      print "Please assign a channel to the unmute app: "
      channel_name = gets.chomp
      unless bot_conversation_names.include?(channel_name)
        print "Please enter a valid channel #{bot_conversation_names}: "
        channel_name = gets.chomp
      end
      bot_conversations = bot_conversations.find { |channel| channel["name"] == channel_name }
    end

    @channel_id = bot_conversations.first["id"].freeze
    @channel_name = bot_conversations.first["name"].freeze
  end

  private


  def self.get_channel_id(channel_name)
    query = {token: get_slack_token}
    response = Helper.check_response(HTTParty.get(CONVERSATIONS_LIST_URL, query: query))

    found_channel = response["channels"].find { |channel| channel["name"].downcase == channel_name.downcase }

    @channel_id = found_channel["id"].freeze
  end

  def self.list_workspace_users
    return Helper.check_response(HTTParty.get(USERS_LIST_URL, query: query))["members"]
  end


  def self.list_channel_user_ids
    query = {
        token: get_slack_token,
        channel: @channel_id
    }

    return Helper.check_response(HTTParty.get(MEMBERS_LIST_URL, query: query))["members"]
  end

  def load_users
    all_users = list_workspace_users
    sleep(0.5)
    member_id_list = list_channel_user_ids(@channel_id)

    member_list = member_id_list.map do |user_id|
      found_user = all_users.find { |user| user["id"] == user_id }

      if found_user["is_bot"] && found_user["name"].match?(/unmute/)
        @unmute_bot = found_user
      end

      User.new(slack_id: found_user["id"], name: found_user["name"], real_name: found_user["real_name"], is_active: true, group_size: :pair, is_confirmed: false)
    end

    return member_list

    #TODO: bot to send welcome message and set is_active upon response, and change :group_size to user selection --- webhook?
  end

  def self.get_slack_token
    # return ENV["SLACK_TOKEN"]
    return ENV["TEST_TOKEN"]
  end

end