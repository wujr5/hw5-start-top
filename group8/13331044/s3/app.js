// Generated by LiveScript 1.3.1
(function(){
  var Button, addClickingToFetchNumbersToButtons, bubble, addResettingWhenLeaveApp, robot, s2Robot, s4Robot, s3Robot;
  Button = (function(){
    Button.displayName = 'Button';
    var prototype = Button.prototype, constructor = Button;
    function Button(dom){
      var this$ = this;
      this.dom = dom;
      this.state = 'enabled';
      this.name = this.dom.find('.name').text();
      this.dom.addClass('enabled');
      this.dom.click(function(){
        if (this$.state === 'enabled') {
          if (robot.state === 'enabled') {
            this$.constructor.disableOtherButtons(this$);
          }
          this$.wait();
          this$.fetchAndShowNumber();
        }
      });
      this.xhr = null;
      this.fetchAndShowNumber = function(){
        var this$ = this;
        this.xhr = $.get('/' + robot.pointer, function(number){
          this$.done();
          this$.showNumber(number);
          this$.constructor.checkToActiveTheBubble();
          if (robot.state === 'waiting') {
            robot.nextThenCheckAndClickTheBubble();
          }
          if (robot.state === 'enabled') {
            this$.constructor.enableOtherButtons(this$);
          }
        });
        if (robot.state === 'waiting') {
          robot.nextThenCheckAndClickTheBubble();
        }
      };
      this.constructor.buttons.push(this);
    }
    Button.buttons = [];
    Button.disableOtherButtons = function(theClickedButton){
      var i$, ref$, len$, button;
      for (i$ = 0, len$ = (ref$ = this.buttons).length; i$ < len$; ++i$) {
        button = ref$[i$];
        if (button.state !== 'done' && button !== theClickedButton) {
          button.disable();
        }
      }
    };
    Button.enableOtherButtons = function(theClickedButton){
      var i$, ref$, len$, button;
      for (i$ = 0, len$ = (ref$ = this.buttons).length; i$ < len$; ++i$) {
        button = ref$[i$];
        if (button.state !== 'done' && button !== theClickedButton) {
          button.enable();
        }
      }
    };
    Button.checkToActiveTheBubble = function(){
      var i$, ref$, len$, button;
      for (i$ = 0, len$ = (ref$ = this.buttons).length; i$ < len$; ++i$) {
        button = ref$[i$];
        if (button.state !== 'done') {
          return false;
        }
      }
      bubble.enableTheBubble();
      return true;
    };
    Button.reset = function(){
      var i$, ref$, len$, button;
      for (i$ = 0, len$ = (ref$ = this.buttons).length; i$ < len$; ++i$) {
        button = ref$[i$];
        if (button.xhr && button.xhr.readyState !== 4) {
          button.xhr.abort();
        }
        button.state = 'enabled';
        button.dom.find('.number').text('');
        button.dom.find('.number').css('display', 'none');
        button.dom.removeClass('disabled done waiting enabled').addClass('enabled');
      }
    };
    prototype.wait = function(){
      this.state = "waiting";
      this.dom.removeClass('enabled').addClass('waiting');
      this.dom.find('.number').text('...');
      this.dom.find('.number').css('display', 'block');
    };
    prototype.done = function(){
      this.state = "done";
      this.dom.removeClass('waiting').addClass('done');
    };
    prototype.disable = function(){
      this.state = "disabled";
      this.dom.removeClass('enabled').addClass('disabled');
    };
    prototype.enable = function(){
      this.state = "enabled";
      this.dom.removeClass('disabled').addClass('enabled');
    };
    prototype.showNumber = function(number){
      this.dom.find('.number').text(number);
    };
    return Button;
  }());
  addClickingToFetchNumbersToButtons = function(next){
    var i$, ref$, len$;
    for (i$ = 0, len$ = (ref$ = $('#control-ring .button')).length; i$ < len$; ++i$) {
      (fn$.call(this, ref$[i$]));
    }
    function fn$(dom){
      var button;
      button = new Button($(dom));
    }
  };
  bubble = {
    initial: function(){
      var this$ = this;
      this.obj = $('.info');
      this.obj.addClass('disabled');
      this.obj.click(function(){
        if (this$.obj.hasClass('enabled')) {
          this$.clickToSumAndShow();
        }
      });
    },
    clickToSumAndShow: function(){
      var sum, i$, ref$, len$, dom;
      sum = 0;
      for (i$ = 0, len$ = (ref$ = $('.button')).length; i$ < len$; ++i$) {
        dom = ref$[i$];
        sum += parseInt($(dom).find('.number').text());
      }
      this.obj.find('.sum').text(sum);
    },
    reset: function(){
      this.obj.find('.sum').text('');
      this.obj.removeClass('enabled').addClass('disabled');
    },
    enableTheBubble: function(){
      this.obj.removeClass('disabled').addClass('enabled');
    }
  };
  addResettingWhenLeaveApp = function(){
    var app;
    app = $('#at-plus-container');
    app.on('mouseleave', function(){
      Button.reset();
      bubble.reset();
      robot.reset();
    });
  };
  robot = {
    initial: function(){
      var this$ = this;
      this.app = $('.icon');
      this.buttons = $('.button');
      this.bubble = bubble.obj;
      this.order = [0, 1, 2, 3, 4];
      this.pointer = 0;
      this.state = "enabled";
      this.app.click(function(){
        this$.state = "waiting";
        if (this$.state === 'waiting') {
          this$.showOrder();
        }
        this$.nextThenCheckAndClickTheBubble();
      });
    },
    nextThenCheckAndClickTheBubble: function(){
      var this$ = this;
      if (this.pointer === this.order.length) {
        setTimeout(function(){
          this$.bubble.click();
          if (Button.checkToActiveTheBubble()) {
            this$.state = "done";
          }
        }, 0);
      } else {
        this.getTheNextButton().click();
      }
    },
    getTheNextButton: function(){
      return this.buttons[this.order[this.pointer++]];
    },
    reset: function(){
      this.state = "enabled";
      this.pointer = 0;
      this.bubble.find('.order').text('');
    },
    showOrder: function(){
      var number;
      this.bubble.find('.order').text((function(){
        var i$, ref$, len$, results$ = [];
        for (i$ = 0, len$ = (ref$ = this.order).length; i$ < len$; ++i$) {
          number = ref$[i$];
          results$.push(String.fromCharCode(number + 'A'.charCodeAt()));
        }
        return results$;
      }.call(this)).join(' '));
    }
  };
  s2Robot = function(){
    robot.initial();
  };
  s4Robot = function(){
    robot.initial();
    robot.order.sort(function(){
      return Math.random() > 0.5;
    });
  };
  s3Robot = function(){
    robot.initial();
  };
  $(function(){
    addClickingToFetchNumbersToButtons();
    bubble.initial();
    s3Robot();
    addResettingWhenLeaveApp();
  });
}).call(this);
