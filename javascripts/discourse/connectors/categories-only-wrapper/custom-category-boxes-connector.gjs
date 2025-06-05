import Component from "@ember/component";
import { tagName } from "@ember-decorators/component";
import CustomCategoryBox from "../../components/custom-category-box";

@tagName("")
export default class CustomCategoryBoxesConnector extends Component {
  <template>
    <div class="custom-categories-wrapper">
      {{#each @outletArgs.categories as |category|}}
        <CustomCategoryBox @category={{category}} />
      {{/each}}
    </div>
  </template>
}
