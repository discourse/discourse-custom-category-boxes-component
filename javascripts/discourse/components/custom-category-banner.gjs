import Component from "@glimmer/component";
import { cached } from "@glimmer/tracking";
import { service } from "@ember/service";
import { htmlSafe } from "@ember/template";
import htmlClass from "discourse/helpers/html-class";
import Category from "discourse/models/category";

export default class CustomCategoryBanner extends Component {
  @service router;

  @cached
  get category() {
    if (!this.isCategoryRoute) {
      return;
    }

    return Category.findBySlugPathWithID(
      this.router.currentRoute.params.category_slug_path_with_id
    );
  }

  get bgIndex() {
    return Math.floor(Math.random() * 4);
  }

  get isCategoryRoute() {
    return this.router.currentRoute.name === "discovery.category";
  }

  get shouldShow() {
    return this.isCategoryRoute && settings.show_banner;
  }

  get styleAttribute() {
    if (!this.category) {
      return null;
    }

    const bgColor = `#${this.category.color}65`;
    const bgKey = `${settings.category_background}-${this.bgIndex}`;
    const bgImage = `url(${settings.theme_uploads[bgKey]})`;
    const border = `1px solid #${this.category.color}`;
    const boxShadow = `8px 8px 0 #${this.category.color}32`;

    const styleString = `
      background-color: ${bgColor};
      background-image: ${bgImage};
      border: ${border};
      box-shadow: ${boxShadow};
    `.trim();

    return htmlSafe(styleString);
  }

  <template>
    {{#if this.shouldShow}}
      {{htmlClass "category-page-custom-banner"}}
      <div class="custom-category-banner-wrapper">
        <div class="custom-category-banner" style={{this.styleAttribute}}>
          <h1 class="custom-category-banner-title">{{this.category.name}}</h1>
        </div>
      </div>
    {{/if}}
  </template>
}
