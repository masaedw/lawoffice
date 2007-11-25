// Place your application-specific JavaScript functions and classes here
// This file is automatically included by javascript_include_tag :defaults

var ZINDEXTOP = 100;

Element.Methods.popup = function(element)
{
  $(element).setStyle({"zIndex": ZINDEXTOP++});
  return element;
};

Element.addMethods();

// IE でも動くの？これ
Abstract.EventObserver.prototype.updateLastValue = function()
{
  this.lastValue = this.getValue();
};

Abstract.TimedObserver.prototype.updateLastValue = function()
{
  this.lastValue = this.getValue();
};

//------------------------------------------------------------
// Window
// エレメントの外側をクリックされたことの検知をするためのしくみ
//
// var win = new Window('id');
// win.onfocus = function(event) { ... };
// win.onunfocus = function(event) { ... };
//
// とすれば、エレメントをクリックされたときにフォーカスを得ることができ、
// エレメント外をクリックされるとフォーカスを失うようになる。
//
// フォーカスを得た場合には、onfocus
// 失った場合には、onunfocus
// がそれぞれ呼ばれる。
//

// クリックされたのがエレメント内か？
Event.inElement = function(event, elem)
{
  var element = Event.element(event);
  while (element != elem) {
    if (element.parentNode)
      element = element.parentNode;
    else
      return false;
  }
  return true;
};

//------------------------------------------------------------

var Window = Class.create();

Window.initialized = false;
Window.listeners_ = $A([]);

Window.init = function()
{
  if (Window.initialized) return;
  Window.initialized = true;

  Event.observe(document, "click", function(event) {
    var retVal;
    this.listeners_.each(function(i) {
      if (!Event.inElement(event, $(i.elem_id))) {
        if (!i.focus__) return;
        i.focus__ = false;

        if (typeof(i.onunfocus) == "function")
            retVal = i.onunfocus(event);
      }
    });
    return retVal;
  }.bindAsEventListener(Window));
};

Window.add = function(window)
{
  this.listeners_.push(window);
};

Window.remove = function(window)
{
  this.listeners_ =
    this.listeners_.reject(function(i) {
      return i == window;
    });
};

Window.prototype = {
  initialize: function(elem)
  {
    Window.init();

    this.elem_id = $(elem).id;
    this.focus__ = false;

    Window.add(this);

    Event.observe($(elem), "click", function(event) {
      if (this.focus__) return;
      this.focus__ = true;

      $(this.elem_id).popup();
      if (typeof(this.onfocus) == "function")
        return this.onfocus(event);
    }.bindAsEventListener(this));
  }
};


//------------------------------------------------------------
// ObjectPool
// idと一対一対応をもつオブジェクトを溜めておくしくみ
var ObjectPool = new Object;

ObjectPool.find = function(id)
{
  return this.objectpool__[id];
};

ObjectPool.register = function(id, object)
{
  if (!this.objectpool__)
    this.objectpool__ = $H({});
  this.objectpool__[id] = object;
};

ObjectPool.remove = function(id)
{
  this.objectpool__.remove(id);
};


//------------------------------------------------------------
// 自分が発行したイベントに対応するJSの実行を防ぐためのしくみ
//
function sid_is(sid)
{
  return sid__ == sid;
}
