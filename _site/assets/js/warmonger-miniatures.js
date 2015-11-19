---
~include:
  - bower_components/jquery/dist/jquery.js
  - bower_components/bootstrap/dist/js/bootstrap.js
  - bower_components/blueimp-gallery/js/jquery.blueimp-gallery.js
  - bower_components/blueimp-bootstrap-image-gallery/js/bootstrap-image-gallery.js
include:
  - _site/_assets/javascripts/gcse.js
---
$(function () {
  'use strict';

  $('html').first().toggleClass('js no-js');

  $("a[href^='mailto:']").each(function (i, e) {
    var $e = $(e);

    $e
      .attr('href',
        $e.attr('href')
          .replace(/ *\(at\) */gi, '@')
          .replace(/ *\(dot\) */gi, '.'))
      .html(
        $e.html()
          .replace(/ *\(at\) */gi, '@')
          .replace(/ *\(dot\) */gi, '.')
      );
  });
});