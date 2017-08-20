require 'rails_helper'

RSpec.describe "whitelists/edit", type: :view do
  before(:each) do
    @whitelist = assign(:whitelist, Whitelist.create!(
      :user_id => 1,
      :instagram_user_id => "MyString"
    ))
  end

  it "renders the edit whitelist form" do
    render

    assert_select "form[action=?][method=?]", whitelist_path(@whitelist), "post" do

      assert_select "input[name=?]", "whitelist[user_id]"

      assert_select "input[name=?]", "whitelist[instagram_user_id]"
    end
  end
end
