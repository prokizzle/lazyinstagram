require 'rails_helper'

RSpec.describe "whitelists/show", type: :view do
  before(:each) do
    @whitelist = assign(:whitelist, Whitelist.create!(
      :user_id => 2,
      :instagram_user_id => "Instagram User"
    ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(/2/)
    expect(rendered).to match(/Instagram User/)
  end
end
