import Component from "@glimmer/component";
import { tracked } from "@glimmer/tracking";
import { concat } from "@ember/helper";
import { action } from "@ember/object";
import didInsert from "@ember/render-modifiers/modifiers/did-insert";
import didUpdate from "@ember/render-modifiers/modifiers/did-update";
import { service } from "@ember/service";
import { htmlSafe } from "@ember/template";
import htmlClass from "discourse/helpers/html-class";
import Category from "discourse/models/category";

export default class CustomCategoryBanner extends Component {
  @service router;

  @tracked category = null;

  get bgIndex() {
    return Math.floor(Math.random() * 4);
  }

  get isCategoryRoute() {
    return this.router.currentRoute.name === "discovery.category";
  }

  get shouldShow() {
    return this.isCategoryRoute && settings.show_banner;
  }

  get backgroundColor() {
    return `#${this.category.color}65`;
  }

  get backgroundImage() {
    const bgKey = `${settings.category_background}-${this.bgIndex}`;
    return `url(${settings.theme_uploads[bgKey]})`;
  }

  get border() {
    return `1px solid #${this.category.color}`;
  }

  get boxShadow() {
    return `8px 8px 0 #${this.category.color}32`;
  }

  @action
  loadCategory() {
    if (this.isCategoryRoute) {
      this.category = Category.findBySlugPathWithID(
        this.router.currentRoute.params.category_slug_path_with_id
      );
    }
  }

  <template>
    {{#if this.shouldShow}}
      {{htmlClass "category-page-custom-banner"}}
      <div
        class="custom-category-banner-wrapper"
        {{didInsert this.loadCategory}}
        {{didUpdate this.loadCategory this.router.currentRoute}}
      >
        <div
          class="custom-category-banner"
          style={{htmlSafe
            (concat
              "background-color: "
              this.backgroundColor
              ";"
              "background-image: "
              this.backgroundImage
              ";"
              "border: "
              this.border
              ";"
              "box-shadow: "
              this.boxShadow
              ";"
            )
          }}
        >
          <h1 class="custom-category-banner-title">{{this.category.name}}</h1>
        </div>
      </div>
    {{/if}}
  </template>
}
