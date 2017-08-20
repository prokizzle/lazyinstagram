require 'rails_helper'

RSpec.describe "whitelists/index", type: :view do
  before(:each) do
    assign(:whitelists, [
      Whitelist.create!(
        :user_id => 2,
        :instagram_user_id => "Instagram User"
      ),
      Whitelist.create!(
        :user_id => 2,
        :instagram_user_id => "Instagram User"
      )
    ])
  end
end
