require_relative 'test_helper'
require_relative '../lib/lunchroom'

describe "Lunchroom class" do

  describe "Lunchroom instantiation" do

    before do
      @new_lunchroom = Lunchroom.new
    end

    it "is an instance of Lunchroom" do
      expect(@new_lunchroom).must_be_instance_of Lunchroom
    end

    it "establishes the base data structures when instantiated" do
      [:users, :tables].each do |keyword|
        expect(@new_lunchroom).must_respond_to keyword
      end

      expect(@new_lunchroom.users).must_be_kind_of Array
      expect(@new_lunchroom.users).must_be_empty
      expect(@new_lunchroom.tables).must_be_kind_of Array
      expect(@new_lunchroom.tables).must_be_empty
    end

  end

  describe ".load_users" do

    before do
      VCR.use_cassette("load member and user list") do
        @new_lunchroom = Lunchroom.new
        @new_lunchroom.load_users
      end
    end

    it "populates the @users instance variable" do
      expect(@new_lunchroom.users).wont_be_empty
    end

  end

  describe ".load_unmute_bot" do

    before do
      VCR.use_cassette("load member and user list") do
        @new_lunchroom = Lunchroom.new
        @new_lunchroom.load_unmute_bot
      end
    end

    it "populates the @unumute_bot instance variable" do
      expect(@new_lunchroom.unmute_bot).wont_be_empty
    end

  end


end