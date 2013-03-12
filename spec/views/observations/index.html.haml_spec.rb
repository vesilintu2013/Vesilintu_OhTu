require 'spec_helper'

describe "observations/index.html.haml" do
  it "renders the _search partial" do
    render

    expect(view).to render_template(:partial => "_search")
  end

  it "renders the _header partial" do
    render :template => 'observations/index', :layout => 'layouts/application'

    expect(view).to render_template(:partial => "_header")
  end
end
