require 'spec_helper'

describe 'search_overview' do
  it 'loads' do
    visit search_overview_path
    expect(page.status_code).to eq(200)
  end
end
