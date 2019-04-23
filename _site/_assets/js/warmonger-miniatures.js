//= require baseline
//= require_tree .

$(function () {
  var
    $modal = $('#modal').modal({
      closingAnimation: 'fadeOut',
      control: $('.card.image a, .shared-images .images a'),
      open: false,
      openingAnimation: 'fadeIn'
    }),
    $slideshow = $('.slideshow').has('> * + *')
      .slideshow()
      .on('slideshow:sliding', function (event, extraParameters) {
        // when a slide happens while the modal is open
        if ($modal.is(':visible:not(".ignore-slideshow-slide")')) {
          // have the modal return focus to the active slide
          $modal.data('last-focus', extraParameters.$toSlide.find(':all-focusable').get(0));
        }
      });

  $('#sidebar')
    .accessibleToggle();

  $('#news ul[data-control], #store ul[data-control]')
    .each(function () {
      var $ul = $(this);

      $ul.
        accessibleToggle({
          hidden: !$ul.has('a:not([href])').length && $ul.prev('a[href]').length,
          parent: $ul.parent().closest('ul')
        });
    });

  $('.card.image')
    .on('click', 'a', function (event, extraParameters = {}) {
      var
        $a = $(event.currentTarget),
        $delegateTarget = $(event.delegateTarget),
        $prev = $delegateTarget.prev('.card.image').find('a'),
        $next = $delegateTarget.next('.card.image').find('a');

      function pagerClick ($link, focus) {
        $modal
          .one('modal:opened', function (event) {
            // don't return focus to this button when the modal closes, use the active slide
            $modal.data('last-focus', $slideshow.find('.active :focusable').get(0));
          });

        $link.trigger('click', { focus: focus });

        // kill this click so the modal won't close
        return false;
      }

      if (!$prev.length) {
        $prev = $delegateTarget.nextUntil(':not(.card.image)').last().find('a');
      }

      if (!$next.length) {
        $next = $delegateTarget.prevUntil(':not(.card.image)').last().find('a');
      }

      $modal.find('.modal-title')
        .text($a.find('figcaption').text());

      $modal.find('.modal-body')
        .html(
          $('<img>')
            .attr('alt', $a.find('img').attr('alt'))
            .attr('src', $a.attr('href'))
        )
        .append(
          $('<div class="pager">')
            .append(
              $('<button class="small previous">')
                .prop('hidden', $prev.length < 1)
                .text('Previous')
                .one('click', function () {
                  return pagerClick($prev, '.previous');
                }),
              $('<button class="small next">')
                .prop('hidden', $next.length < 1)
                .text('Next')
                .one('click', function () {
                  return pagerClick($next, '.next');
                })
            )
        );

      // focus on the previous/next button
      $modal.find(extraParameters.focus).focus();

      // don't follow the link
      return false;
    });

  $('.shared-images .images a')
    .on('click', function () {
      var
        $a = $(this),
        $prev = $a.prev('a'),
        $next = $a.next('a');

      function pagerClick ($link) {
        $modal
          .one('modal:opened', function (event) {
            // don't return focus to this button when the modal closes, use $link instead
            $modal.data('last-focus', $link.get(0));
          });

        $link.trigger('click');

        // kill this click so the modal won't close
        return false;
      }

      if (!$prev.length) {
        $prev = $a.nextUntil(':not(a)').last();
      }

      if (!$next.length) {
        $next = $a.prevUntil(':not(a)').last();
      }

      $modal
        .addClass('ignore-slideshow-slide')
        .one('modal:closed', function () {
          $modal.removeClass('ignore-slideshow-slide');
        });

      $modal.find('.modal-title')
        .html(function () {
          var html = 'Shared by ';

          if ($a.data('modal-title-url') !== '') {
            html += $('<a>')
              .attr('href', $a.data('modal-title-url'))
              .attr('target', '_blank')
              .text($a.data('modal-title'))
              .get(0).outerHTML;
          } else {
            html += $a.data('modal-title');
          }

          return html;
        });

      $modal.find('.modal-body')
        .html(
          $('<img>')
            .attr('alt', $a.find('img').attr('alt'))
            .attr('src', $a.attr('href'))
        )
        .append(
          $('<div class="pager">')
            .append(
              $('<button class="small previous">')
                .prop('hidden', $prev.length < 1)
                .text('Previous')
                .one('click', function () {
                  return pagerClick($prev);
                }),
              $('<button class="small next">')
                .prop('hidden', $next.length < 1)
                .text('Next')
                .one('click', function () {
                  return pagerClick($next);
                })
            )
        );

      // don't follow the link
      return false;
    });
});
