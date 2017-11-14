class AddImpressionsCount7ToWidgets < ActiveRecord::Migration
  def change
    add_column :widgets, :impressions_count_7, :integer, :default => 0
  end
end
