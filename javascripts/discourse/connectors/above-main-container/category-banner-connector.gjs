import Component from "@ember/component";
import { classNames } from "@ember-decorators/component";
import CustomCategoryBanner from "../../components/custom-category-banner";

@classNames("above-main-container-outlet", "category-banner-connector")
export default class CategoryBannerConnector extends Component {
  <template><CustomCategoryBanner /></template>
}
