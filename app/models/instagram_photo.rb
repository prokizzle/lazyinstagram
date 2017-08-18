class InstagramPhoto < ActiveRecord::Base
	acts_as_taggable_on :labels, :hashtags

	scope :females, -> {tagged_with(['female', 'girl'], any: true)}
end