import Component from "@ember/component";
import { computed } from "@ember/object";
import { readOnly } from "@ember/object/computed";
import { afterRender } from "discourse-common/utils/decorators";

export default Component.extend({
  classNames: ["custom-category"],
  topicCount: readOnly("c.topic_count"),
  
  didInsertElement() {
    this._super(...arguments);

    if (this.topicCount) {
      this.set("hasTopics", true)
      this._applyBgColor(this.hexToRgb(this.c.color));
    } else {
      this.element.style.display = "none";
    }
  },

  hexToRgb(hex) {
    // Expand shorthand form (e.g. "03F") to full form (e.g. "0033FF")
    var shorthandRegex = /^#?([a-f\d])([a-f\d])([a-f\d])$/i;
    hex = hex.replace(shorthandRegex, function(m, r, g, b) {
      return r + r + g + g + b + b;
    });
  
    var result = /^#?([a-f\d]{2})([a-f\d]{2})([a-f\d]{2})$/i.exec(hex);
    return result ? {
      r: parseInt(result[1], 16),
      g: parseInt(result[2], 16),
      b: parseInt(result[3], 16)
    } : null;
  },

  @afterRender
  _applyBgColor(color) {
    let rnd = Math.floor(Math.random()*4);
    let bg = `${settings.category_background}-${rnd}`;
    this.element.style.backgroundColor = `rgba(${color.r},${color.g},${color.b},.5)`;
    this.element.style.backgroundImage = `url(${settings.theme_uploads[bg]})`;
    this.element.style.border = `1px solid #${this.c.color}`
    this.element.style.boxShadow = `8px 8px 0 rgba(${color.r},${color.g},${color.b},.25)`
  }
})