require 'rails_helper'

RSpec.describe Pin, :type => :model do
  it "has a title and a description" do
    tabbies = Pin.create!(title: 'Kittens', description: 'All tabbies')

    expect(Pin.title).to eq('Kittens')
    expect(Pin.description).to eq('All tabbies')
  end
end

# https://github.com/rspec/rspec-rails
