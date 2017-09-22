(function($) {
  'use strict';

  var Paginator = function() {
    return {
      // Attributes
      obj: null,
      options: null,
      nav: null,

      // Methods
      build: function(obj, opts) {
        this.obj = obj;
        this.options = opts;

        if(!this.options.optional || this._totalRows() > this.options.limit) {
          this._createNavigation();
          this._setPage();
        }

        if(this.options.onCreate) this.options.onCreate(obj);

        return this.obj;
      },

      _createNavigation: function() {
        this._createNavigationWrapper();
        this._createNavigationButtons();
        this._appendNavigation();
        this._addNavigationCallbacks();
      },
      _createNavigationWrapper: function() {
        this.nav = $('<div>', {
          class: this.options.navigationClass
        });
      },
      _createNavigationButtons: function() {
        // Add 'first' button
        if(this.options.first) {
          this._createNavigationButton(this.options.firstText, {
            'data-first': true
          });
        }

        // Add 'previous' button
        if(this.options.previous) {
          this._createNavigationButton(this.options.previousText, {
            'data-direction': -1,
            'data-previous': true
          });
        }

        // Add page buttons
        for(var i = 0; i < this._totalPages(); ++i) {
          this._createNavigationButton(this.options.pageToText(i), {
            'data-page': i
          });
        }

        // Add 'next' button
        if(this.options.next) {
          this._createNavigationButton(this.options.nextText, {
            'data-direction': 1,
            'data-next': true
          });
        }

        // Add 'last' button
        if(this.options.last) {
          this._createNavigationButton(this.options.lastText, {
            'data-last': true
          });
        }
      },
      _createNavigationButton: function(text, options) {
        this.nav.append($('<a>', $.extend(options, { href: '#', text: text })));
      },
      _appendNavigation: function() {
        // Add the content to the navigation block
        if(this.options.navigationWrapper) this.options.navigationWrapper.append(this.nav);
        // Add it after the table
        else this.obj.after(this.nav);
      },
      _addNavigationCallbacks: function() {
        var paginator = this;

        paginator.nav.find('a').click(function(e) {
          var direction = $(this).data('direction') * 1;

          // 'First' button
          if($(this).data('first') !== undefined) {
            paginator._setPage(0);
          }
          // Page button
          else if ($(this).data('page') !== undefined) {
            paginator._setPage($(this).data('page') * 1);
          }
          // 'Previous' or 'Next' button
          else if ($(this).data('previous') !== undefined || $(this).data('next') !== undefined) {
            var page = paginator._currentPage() + direction;
            if(page >= 0 && page <= paginator._totalPages() - 1) {
              paginator._setPage(page);
            }
          }
          // 'Last' button
          else if ($(this).data('last') !== undefined) {
            paginator._setPage(paginator._totalPages() - 1);
          }

          // Handle callback
          if(paginator.options.onSelect) paginator.options.onSelect(paginator.obj, paginator._currentPage());
          e.preventDefault();
          return false;
        });
      },

      _setPage: function(index) {
        if(index == undefined) index = this.options.initialPage;

        // Hide all elements, and then show the current page.
        this._rows().hide().slice(index * this.options.limit, (index + 1) * this.options.limit).show();

        // Set the current button as active
        this.nav.find('a').removeAttr('data-selected').siblings('a[data-page=' + index + ']')
                .attr('data-selected', true);
      },

      _currentPage: function() {
        return this.nav.find('a[data-selected=true]').data('page');
      },
      _totalRows: function() {
        // Count the total rows of the selector
        return this._rows().length;
      },
      _rows: function() {
        return this.obj.find(this.options.childrenSelector);
      },
      _totalPages: function() {
        return Math.ceil(this._totalRows() / this.options.limit);
      }
    };
  };

  $.fn.paginate = function(options) {
    switch(options) {
      // Example of custom actions:
      // case 'destroy': return pagination.destroy(this);
      default: return Paginator().build(this, $.extend( {}, $.fn.paginate.defaults, options));
    }
  };

  $.fn.paginate.defaults = {
    limit: 20,
    initialPage: 0,

    previous: true,
    previousText: '<',
    next: true,
    nextText: '>',
    first: true,
    firstText: '<<',
    last: true,
    lastText: '>>',

    optional: true,

    onCreate: null,
    onSelect: null,

    childrenSelector: 'tbody > tr',
    navigationWrapper: null,
    navigationClass: 'page-navigation',
    pageToText: function(i) { return (i + 1).toString(); }
  }

}(jQuery));
