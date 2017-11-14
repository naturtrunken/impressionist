require 'spec_helper'

describe Impression do
  fixtures :widgets

  let(:widget) { Widget.find(1) }

  before(:each) do
    Impression.destroy_all
  end

  describe "self#impressionist_counter_caching?" do
    it "should know when counter caching is enabled" do
      Widget.should be_impressionist_counter_caching
    end

    it "should know when counter caching is disabled" do
      Article.should_not be_impressionist_counter_caching
    end
  end

  describe "self#counter_caching?" do
    it "should know when counter caching is enabled" do
      ActiveSupport::Deprecation.should_receive(:warn)
      Widget.should be_counter_caching
    end

    it "should know when counter caching is disabled" do
      ActiveSupport::Deprecation.should_receive(:warn)
      Article.should_not be_counter_caching
    end

  end

  describe "#update_impressionist_counter_cache" do
    it "should update the counter cache column to reflect the correct number of impressions" do
      expect {
         widget.impressions.create(:request_hash => 'abcd1234')
         widget.reload
       }.to change(widget, :impressions_count).from(0).to(1)
    end

    it "should not update the timestamp on the impressable" do
      expect {
         widget.impressions.create(:request_hash => 'abcd1234')
         widget.reload
       }.to_not change(widget, :updated_at)
    end

    it "should update the global counter cache column with all impressions" do
      expect {
        widget.impressions.create(:request_hash => 'abcd1234')
        widget.impressions.create(:request_hash => 'abcd123456').update_attribute(:created_at, Time.now - 1.day)
        widget.impressions.create(:request_hash => 'abcd12345').update_attribute(:created_at, Time.now - 14.day)
        widget.reload
      }.to change(widget, :impressions_count).from(0).to(3)
    end

    it "should update the extended counter cache column with the proper impressions count" do
      expect {
        widget.impressions.create(:request_hash => 'abcd1234')
        widget.impressions.create(:request_hash => 'abcd123456').update_attribute(:created_at, Time.now - 1.day)
        widget.impressions.create(:request_hash => 'abcd12345').update_attribute(:created_at, Time.now - 14.day)
        widget.reload
      }.to change(widget, :impressions_count_7).from(0).to(2)
    end

  end

end
