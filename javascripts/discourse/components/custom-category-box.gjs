import Component from "@glimmer/component";
import { htmlSafe } from "@ember/template";
import CategoriesBoxesTopic from "discourse/components/categories-boxes-topic";
import CategoryTitleBefore from "discourse/components/category-title-before";
import CdnImg from "discourse/components/cdn-img";
import icon from "discourse-common/helpers/d-icon";
import i18n from "discourse-common/helpers/i18n";

function hexToRgb(hex) {
  // Expand shorthand form (e.g. "03F") to full form (e.g. "0033FF")
  hex = hex.replace(
    /^#?([a-f\d])([a-f\d])([a-f\d])$/i,
    (_, r, g, b) => r + r + g + g + b + b
  );

  const result = /^#?([a-f\d]{2})([a-f\d]{2})([a-f\d]{2})$/i.exec(hex);
  return result
    ? {
        r: parseInt(result[1], 16),
        g: parseInt(result[2], 16),
        b: parseInt(result[3], 16),
      }
    : null;
}

export default class CustomCategoryBox extends Component {
  get hasTopics() {
    return this.args.category.topic_count > 0;
  }

  get color() {
    return hexToRgb(this.args.category.color);
  }

  get bgIndex() {
    return Math.floor(Math.random() * 4);
  }

  get backgroundImageUrl() {
    const bgKey = `${settings.category_background}-${this.bgIndex}`;
    return settings.theme_uploads[bgKey];
  }

  get styleAttribute() {
    if (!this.hasTopics || !this.color) {
      return null;
    }

    const { r, g, b } = this.color;
    const borderColor = this.args.category.color;
    const bgUrl = this.backgroundImageUrl;

    const styleString = `
      background-color: rgba(${r}, ${g}, ${b}, 0.5);
      background-image: url(${bgUrl});
      border: 1px solid #${borderColor};
      box-shadow: 8px 8px 0 rgba(${r}, ${g}, ${b}, 0.25);
    `;

    return htmlSafe(styleString.trim());
  }

  <template>
    {{#if this.hasTopics}}
      <div class="custom-category" style={{this.styleAttribute}}>
        <section>
          <a href={{@category.url}}>
            {{#unless @category.isMuted}}
              {{#if @category.uploaded_logo.url}}
                <CdnImg
                  src={{@category.uploaded_logo.url}}
                  class="logo"
                  width={{@category.uploaded_logo.width}}
                  height={{@category.uploaded_logo.height}}
                />
              {{/if}}
            {{/unless}}

            <h2 id="custom-category-title">
              <CategoryTitleBefore @categoryategory={{@category}} />
              {{#if @category.read_restricted}}
                {{icon "lock"}}
              {{/if}}
              {{@category.name}}
              ({{@category.topic_count}})
            </h2>
          </a>
          {{#unless @category.isMuted}}
            <div class="custom-featured-topics">
              {{#if @category.topics}}
                <ul>
                  {{#each @category.topics as |topic|}}
                    <CategoriesBoxesTopic @topic={{topic}} />

                  {{/each}}
                </ul>
              {{/if}}
            </div>
          {{/unless}}
        </section>

        <a class="custom-category-more-link" href={{@category.url}}>
          {{i18n (themePrefix "more_topics")}}...
        </a>

      </div>
    {{/if}}
  </template>
}
