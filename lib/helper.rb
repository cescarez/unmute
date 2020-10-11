require 'httparty'
require_relative 'slack_api_error'


module Helper

  def self.titleize(string)
    string.split(' ').each { |word| word.capitalize! }.join(' ')
  end

  private




  def self.check_response(response)
    if response.code != 200 || response["ok"] != true
      #todo: check Postman for request response -- does endpoint url exist in header? if so, string interpolate in the below error message -- perhaps with built-in HTTParty::Response method #request
      raise SlackApiError, "Request to API endpoint failed with error code #{response.code} and #{response["error"]}."
    else
      return response
    end
  end

end