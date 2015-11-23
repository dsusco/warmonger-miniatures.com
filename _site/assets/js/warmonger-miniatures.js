---
include:
  - bower_components/jquery/dist/jquery.js
  - bower_components/bootstrap/dist/js/bootstrap.js
  - bower_components/blueimp-gallery/js/blueimp-gallery.js
  - bower_components/blueimp-gallery/js/jquery.blueimp-gallery.js
  - bower_components/blueimp-bootstrap-image-gallery/js/bootstrap-image-gallery.js
---
$(function () {
  'use strict';

  $('html').first().toggleClass('js no-js');

  // replace bot-safe e-mails
  $("a[href^='mailto:']").each(function forEachMailtoLink(i, e) {
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

  var
    $currentPost = $('#current-post'),
    $localNav = $('.local-nav').css('margin-left', '1.5em');

  // if not on the post, set it to the first one
  if ($currentPost.length === 0) {
    $currentPost = $('ul:not(:has(ul)) a', $localNav).first();
  }

  // hide all local nav menus, watching for clicks to open
  $('ul', $localNav)
    .hide()
    .filter(':has(ul)').add($localNav)
      .find('> li > .fa')
        .addClass('fa-plus-square-o')
        .click(function localNavExpandClick() {
          $(this)
            .toggleClass('fa-plus-square-o fa-minus-square-o')
            .siblings('ul')
              .toggle();
        });

  // open all the local nav menus that lead to the current post
  $currentPost.parents('li:has(ul)')
    .find('> .fa')
      .toggleClass('fa-plus-square-o fa-minus-square-o')
      .siblings('ul')
        .toggle();
});