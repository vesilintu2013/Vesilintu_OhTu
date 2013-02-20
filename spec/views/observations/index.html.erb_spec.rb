require "spec_helper"

describe "observations/index.html.erb" do
  it "displays all the observations" do
    assign(:observations, [
      stub_model(Observation, :id => '1'),
      stub_model(Observation, :id => '2')
    ])
 
    render

    expect(rendered).to include(observation_path(1))
    expect(rendered).to include(observation_path(2))
  end
end
