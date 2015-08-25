require 'rails_helper'

RSpec.describe "pins/index.html.haml", type: :view do
  it "says placeholder" do
    render
    expect(rendered).to match("Placeholder")
  end
end
