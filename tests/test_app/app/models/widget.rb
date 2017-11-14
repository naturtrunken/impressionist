class Widget < ActiveRecord::Base
  is_impressionable :counter_cache => true, :unique => :request_hash, :extended_counter_cache => { 'impressions_count_7' => -7.days }
end
