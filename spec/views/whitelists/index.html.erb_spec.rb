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

  it "renders a list of whitelists" do
    render
    assert_select "tr>td", :text => 2.to_s, :count => 2
    assert_select "tr>td", :text => "Instagram User".to_s, :count => 2
  end
end
