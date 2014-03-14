window.assert = (function(){
  var assert = function(what) {
    if (!what) {
      throw new Error('Assertion failed');
    }
  };

  assert.el = function($el) {
    if (!$el || $el.length == 0) {
      throw new Error('Assertion failed');
    }
  }

  return assert;
})();

window.VisualSelect = (function(){
  return Spine.Controller.sub({
    elements: {
      'input': '$input'
    },

    events: {
      'click .choice': 'selectAction'
    },

    init: function() {
      this.$choices = this.$el;
      assert.el(this.$el);
      assert.el(this.$input);

      var id = this.$input.val();
      if (id) {
        this.selectById(id);
      } else {
        // this.selectAtIndex(0);
      }
    },

    children: function(selector) {
      var children = this.$choices.children();
      // debugger;
      if (selector) {
        return children.filter(selector);
      } else {
        return children;
      }
    },

    selectAction: function(ev) {
      var $target = $(ev.currentTarget);
      if ($target.hasClass('delete')) return;
      var $choice = $target.closest('.choice');
      var index = this.children().index($choice);
      this.selectAtIndex(index);
    },

    selectAtIndex: function(index) {
      var $choice = this.children().eq(index);
      this.selectObject($choice);
    },

    selectById: function(id) {
      var $choice = this.children('[data-id=' + id + ']');
      this.selectObject($choice);
    },

    selectObject: function($choice) {
      this.children().removeClass('selected');
      $choice.addClass('selected');
      var id = $choice.attr('data-id');
      this.$input.val(id);
    }
  });
})();