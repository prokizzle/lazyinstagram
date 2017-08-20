require 'rails_helper'

RSpec.describe "whitelists/new", type: :view do
  before(:each) do
    assign(:whitelist, Whitelist.new(
      :user_id => 1,
      :instagram_user_id => "MyString"
    ))
  end

  it "renders new whitelist form" do
    render

    assert_select "form[action=?][method=?]", whitelists_path, "post" do

      assert_select "input[name=?]", "whitelist[user_id]"

      assert_select "input[name=?]", "whitelist[instagram_user_id]"
    end
  end
end
