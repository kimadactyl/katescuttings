// This file is automatically compiled by Webpack, along with any other files
// present in this directory. You're encouraged to place your actual application logic in
// a relevant structure within app/javascript and only use these pack files to reference
// that code so it'll be compiled.

// Uncomment to copy all static images under ../images to the output folder and reference
// them with the image_pack_tag helper in views (e.g <%= image_pack_tag 'rails.png' %>)
// or the `imagePath` JavaScript helper below.
//
// const images = require.context('../images', true)
// const imagePath = (name) => images(name, true)

require("@rails/ujs").start()
require("turbolinks").start()
require("@rails/activestorage").start()
require("channels")

const { Luminous, LuminousGallery } = require("luminous-lightbox");

const initGalleries = () => {
  const galleries = document.querySelectorAll(".gallery");
  galleries.forEach((gallery) => {
    initLightbox(gallery.querySelectorAll(".lightbox"));
  })
}

const initLightbox = (lightbox) => {
  if(lightbox.length === 1) {
    new Luminous(lightbox[0]);
  } else if(lightbox.length > 1) {
    new LuminousGallery(lightbox);
  }
}

document.addEventListener("turbolinks:load", initGalleries);

require("trix")
require("@rails/actiontext")