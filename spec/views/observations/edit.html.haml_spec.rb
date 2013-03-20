require 'spec_helper'

describe "observations/edit.html.haml" do
  it "renders the _header partial" do
    render :template => 'observations/search', :layout => 'layouts/application'

    expect(view).to render_template(:partial => "_header")
  end
end
