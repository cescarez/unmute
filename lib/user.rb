require_relative 'helper'

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



end