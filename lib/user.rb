require 'httparty'
require_relative 'slack_api_error'
require_relative 'helper'

USERS_LIST_URL = "https://slack.com/api/users.list"
VALID_GROUP_SIZES = [:pair, :small_group]


class User
  attr_reader :slack_id, :name, :real_name, :is_active, :group_size, :is_confirmed

  def initialize(slack_id:, name:, real_name: "", is_active: false, group_size: :pair, is_confirmed: false)
    @slack_id = slack_id.upcase
    @name = name.downcase
    @real_name = Helper::titleize(real_name)
    @is_active = is_active
    @group_size = group_size
    @is_confirmed = is_confirmed
  end


  def change_group_size
    if @group_size == :pair
      @group_size = :small_group
    else
      @group_size = pair
    end
  end


  def change_active_status
    if @is_active
      @is_active = false
    else
      @is_active = true
    end
  end

  def change_confirmation_status
    if @is_confirmed
      @is_confirmed = false
    else
      @is_confirmed = true
    end
  end

  private

  def self.get_user_list(url)
    query = {token: get_slack_token}
    response = check_message(HTTParty.get(USERS_LIST_URL, query: query))
    User.new(slack_id: response["id"], name: response["name"], real_name: response["real_name"], is_active: true, group_size: :pair, is_confirmed: false)

    #TODO: bot to send welcome message and set is_active upon response, and change :group_size to user selection --- webhook?
  end

  def self.get_slack_token
    return ENV["SLACK_TOKEN"]
  end


  def self.check_response(response)
    if response.code != 200 || response["ok"] != true
      #todo: check Postman for request response -- does endpoint url exist in header? if so, string interpolate in the below error message
      raise SlackApiError, "Request to API endpoint failed with error code #{response.code} and #{response["error"]}."
    else
      return response
    end
  end

end