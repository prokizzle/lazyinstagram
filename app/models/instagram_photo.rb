class InstagramPhoto < ActiveRecord::Base
	acts_as_taggable_on :labels, :hashtags
    acts_as_taggable_array_on :tags

	scope :females, -> { with_any_tags(['female', 'girl']) }
end
