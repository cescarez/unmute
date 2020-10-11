require 'httparty'
require_relative 'slack_api_error'
require_relative 'helper'

VALID_GROUP_SIZES = [:pair, :small_group]

class User
  attr_reader :slack_id, :name

  def initialize(:slack_id, :name, :real_name = "", :is_active = false, :group_size = :pair, :is_confirmed = false)
    @slack_id = [:slack_id].upcase
    @name = [:name].downcase
    @real_name = Helper::titlelize([:real_name])
    @is_active = [:is_active]
    @group_size = [:group_size]
    @is_confirmed = [:is_confirmed]
  end

  def self.get(url)
    query = {token: get_slack_token}

    return check_message(HTTParty.get(url, query: query))
  end

  private

  def self.get_slack_token
    return ENV["SLACK_TOKEN"]
  end

  def self.check_response(response)
    if response.code != 200 || response["ok"] != true
      raise SlackApiError, "API request failed with error code #{response.code} and #{response["error"]}."
    else
      return response
    end
  end

end