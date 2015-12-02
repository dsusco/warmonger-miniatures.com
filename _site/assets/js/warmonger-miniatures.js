---
include:
  - bower_components/enquire/dist/enquire.js
  - bower_components/js-cookie/src/js.cookie.js
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
    $localNav = $('.local-nav'),
    $widgets = $('#sidebar > *');

  // if not on a post page, set the current post to the first one
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

  // collapse all widgets when screen is xs, uncollapse when not
  enquire.register('screen and (max-width: 720px)', {
    match: function onEnquireMatchXS() {
      $widgets
        .addClass('collapse')
        .filter(function filterShownWidgets() {
          return Cookies.get($(this).attr('id') + 'WidgetShow');
        })
          .addClass('in');
    },
    unmatch: function onEnquireUnmatchXS() {
      $widgets.removeClass('collapse in').removeAttr('style');
    }
  });

  $widgets
    .on('show.bs.collapse', function onWidgetShow() {
      Cookies.set($(this).attr('id') + 'WidgetShow', true)
      $('html, body').animate({ scrollTop: $('#nav').offset().top });
    })
    .on('hide.bs.collapse', function onWidgetHide() {
      Cookies.remove($(this).attr('id') + 'WidgetShow')
    });
});