//= require baseline
//= require_tree .

$(function () {
  var
    $modal = $('#modal').modal({
      closingAnimation: 'fadeOut',
      control: $('.card.image a'),
      open: false,
      openingAnimation: 'fadeIn'
    }),
    $slideshow = $('.slideshow')
      .slideshow()
      .on('slideshow:sliding', function (event, extraParameters) {
        // when a slide happens have the modal return focus to the active slide
        $modal.data('last-focus', extraParameters.$toSlide.find(':all-focusable').get(0));
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
                  $modal
                    .one('modal:opened', function (event) {
                      // don't return focus to this button when the modal closes, use the active slide
                      $modal.data('last-focus', $slideshow.find('.active :focusable').get(0));
                    });

                  $prev.trigger('click', { focus: '.previous' });

                  // kill this click so the modal won't close
                  return false;
                }),
              $('<button class="small next">')
                .prop('hidden', $next.length < 1)
                .text('Next')
                .one('click', function () {
                  $modal
                    .one('modal:opened', function (event) {
                      // don't return focus to this button when the modal closes, use the active slide
                      $modal.data('last-focus', $slideshow.find('.active :focusable').get(0));
                    });

                  $next.trigger('click', { focus: '.next' });

                  // kill this click so the modal won't close
                  return false;
                })
            )
        );

      // focus on the previous/next button
      $modal.find(extraParameters.focus).focus();

      // don't follow the link
      return false;
    });
});
