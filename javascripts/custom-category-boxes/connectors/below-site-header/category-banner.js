import { withPluginApi } from "discourse/lib/plugin-api";

export default {
  setupComponent(args, component) {
    withPluginApi("0.1", (api) => {
      api.onPageChange((url) => {
        let show_banner = settings.show_banner;
        let splitURL = url.split("/");
        let html = document.getElementsByTagName("html")[0];

        if (splitURL[1] === "c") {
          let categoryTitle = splitURL[2];

          let rnd = Math.floor(Math.random() * 4);
          let bg = `${settings.category_background}-${rnd}`;

          let c = this.site.categories.find((cat) => {
            let name = cat.name.toLowerCase().replace(" ", "-");
            if (name === categoryTitle.toLowerCase()) {
              return true;
            }
          });

          html.classList.add("category-page-custom-banner");

          component.setProperties({
            show_banner,
            title: c.name.replace(/^\w/, (cat) => cat.toUpperCase()),
            backgroundColor: `#${c.color}65`,
            backgroundImage: `url(${settings.theme_uploads[bg]})`,
            border: `1px solid #${c.color}`,
            boxShadow: `8px 8px 0 #${c.color}32`,
          });
        } else {
          html.classList.remove("category-page-custom-banner");
          component.setProperties({
            show_banner: false,
          });
        }
      });
    });
  },
};
