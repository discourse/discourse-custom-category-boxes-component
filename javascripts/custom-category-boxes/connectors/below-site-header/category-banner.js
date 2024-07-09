import { withPluginApi } from "discourse/lib/plugin-api";
import Category from "discourse/models/category";

export default {
  setupComponent(args, component) {
    withPluginApi("0.1", (api) => {
      api.onPageChange(async (url) => {
        let show_banner = settings.show_banner;
        let splitURL = url.split("/");
        let html = document.getElementsByTagName("html")[0];

        if (splitURL[1] === "c") {
          let categorySlug = splitURL[2];

          let rnd = Math.floor(Math.random() * 4);
          let bg = `${settings.category_background}-${rnd}`;
          try {
            let c = await Category.asyncFindBySlugPath(categorySlug);
            html.classList.add("category-page-custom-banner");
            component.setProperties({
              show_banner,
              title: c.name.replace(/^\w/, (cat) => cat.toUpperCase()),
              backgroundColor: `#${c.color}65`,
              backgroundImage: `url(${settings.theme_uploads[bg]})`,
              border: `1px solid #${c.color}`,
              boxShadow: `8px 8px 0 #${c.color}32`,
            });
          } catch (e) {
            html.classList.remove("category-page-custom-banner");
            component.set("show_banner", false);
          }
        } else {
          html.classList.remove("category-page-custom-banner");
          component.set("show_banner", false);
        }
      });
    });
  },
};
