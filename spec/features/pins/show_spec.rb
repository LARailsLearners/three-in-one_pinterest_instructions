require 'rails_helper'

RSpec.describe "pins/show.html.haml", type: :view do
  it "has Pin title, description and a back button" do
    assign(:pin,
      Pin.create!(title: 'Squirrels', description: 'Fluffly tailed nut
eaters.'))
    render template: "pins/show.html.haml"
    expect(rendered).to match "Squirrels"
  end
end
