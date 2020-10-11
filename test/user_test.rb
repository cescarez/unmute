require_relative '../test/test_helper'
require_relative '../lib/user'

describe "User class" do

  describe "instantiation" do

    before do
      @new_user = User.new(slack_id: "some_id123", name: "some_username", real_name: "Some Real Name")
    end

    it "is an instance of User" do
      expect(@new_user).must_be_instance_of User
    end

    it "establishes the base data structures when instantiated" do
      [:slack_id, :name, :real_name, :is_active, :group_size, :is_confirmed].each do |keyword|
        expect(@new_user).must_respond_to keyword
      end

      expect(@new_user.slack_id).must_be_kind_of String
      expect(@new_user.name).must_be_kind_of String
      expect(@new_user.real_name).must_be_kind_of String
      expect(@new_user.is_active).must_equal false
      expect(@new_user.group_size).must_equal :pair
      expect(@new_user.is_confirmed).must_equal false
    end

  end


  describe "#change_group_size" do

    before do
      @new_user = User.new(slack_id: "some_id123", name: "some_username", real_name: "Some Real Name")
    end

    it "changes group size" do
      before = @new_user.group_size
      @new_user.change_group_size
      after = @new_user.group_size

      expect(after).wont_equal before
    end

  end

  describe "#change_active_status" do

    before do
      @new_user = User.new(slack_id: "some_id123", name: "some_username", real_name: "Some Real Name")
    end

    it "changes active status" do
      before = @new_user.is_active
      @new_user.change_active_status
      after = @new_user.is_active

      expect(after).wont_equal before
    end

  end

  describe "#change_confirmation_status" do

    before do
      @new_user = User.new(slack_id: "some_id123", name: "some_username", real_name: "Some Real Name")
    end

    it "changes confirmation status" do
      before = @new_user.is_confirmed
      @new_user.change_active_status
      after = @new_user.is_confirmed

      expect(after).wont_equal before
    end

  end



end