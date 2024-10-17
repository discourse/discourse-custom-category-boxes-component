# frozen_string_literal: true
RSpec.describe "DiscourseCustomCategoryBoxes - category banner", system: true do
  fab!(:current_user) { Fabricate(:admin) }

  let(:category_page) { PageObjects::Pages::Category.new }

  context "when using lazy loaded categories" do
    let(:theme) { Fabricate(:theme) }

    let!(:component) { upload_theme_component(parent_theme_id: theme.id) }

    before do
      SiteSetting.lazy_load_categories_groups = "#{Group::AUTO_GROUPS[:everyone]}"
      theme.set_default!
      sign_in(current_user)
    end

    fab!(:category)
    fab!(:topic) { Fabricate(:topic, category: category) }
    fab!(:post) { Fabricate(:post, topic: topic) }

    it "works" do
      visit("/")

      find(".badge-category[data-category-id='#{category.id}']").click

      expect(category_page).to have_css(".custom-category-banner-title", text: category.name)
    end
  end
end
