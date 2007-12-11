// Place your application-specific JavaScript functions and classes here
// This file is automatically included by javascript_include_tag :defaults

if ((typeof console) == "undefined" ||
    !Object.isFunction(console.log)) {
  var console = new Object;
  console.log = function() {};
}

var ZINDEXTOP = 100;

Element.Methods.popup = function(element)
{
  $(element).setStyle({"zIndex": ZINDEXTOP++});
  return element;
};

// pred はDOMエレメントを引数にとる述語
// elementのparentNodeを辿り、predが真になる要素を返す。
// elementそのものもpredによってチェックされる。
Element.Methods.outer_find = function(element, pred) {
  while (!pred($(element))) {
    element = $(element).parentNode;
    if (!element || element == document.body)
      return false;
  }
  return element;
};

Element.addMethods();

Abstract.EventObserver.prototype.updateLastValue = function()
{
  this.lastValue = this.getValue();
};

Abstract.TimedObserver.prototype.updateLastValue = function()
{
  this.lastValue = this.getValue();
};


function id_number(id)
{
  return id.replace(/.*_/, '');
}


function is_valid_color(color)
{
  return !!color.match(/^#([a-f0-9]{3}){1,2}$/i);
}


//------------------------------------------------------------
// IE のバグ対策
// display: none; な要素の子要素のselectをJSで変更すると、
// 非表示だったはずのselect要素が画面上にポツンと表示されてしまう
//
if (document.all) {
Element.Methods.update_orig = Element.Methods.update;

Element.Methods.update = function(element, html) {
  Element.update_orig(element, html);

  var select = Element.outer_find(element, function(elem) {
    return elem.tagName.toUpperCase() == "SELECT";
  });
  if (!select) return element;

  var hidden = Element.outer_find(select, function(elem) {
    return !Element.visible(elem);
  });

  if (hidden) {
    select.form_hidden__ = true;
    Element.hide(select);
  }

  return element;
};

Element.Methods.show_orig = Element.Methods.show;

Element.Methods.show = function(element)
{
  Element.show_orig(element);

  var selects = $(element).getElementsByTagName("SELECT");

  for (var i = 0; i < selects.length; i++) {
    if (selects[i].form_hidden__) {
      Element.show_orig(selects[i]);
      selects[i].form_hidden__ = false;
    }
  }
  return element;
};

Element.addMethods();
}
Object.extend(Element, Element.Methods);

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
  return this.objectpool__.get(id);
};

ObjectPool.register = function(id, object)
{
  if (!this.objectpool__)
    this.objectpool__ = $H();
  this.objectpool__.set(id, object);
};

ObjectPool.remove = function(id)
{
  this.objectpool__.unset(id);
};

ObjectPool.pool = function()
{
  return this.objectpool__.values();
}


//------------------------------------------------------------
// 自分が発行したイベントに対応するJSの実行を防ぐためのしくみ
//
function sid_is(sid)
{
  return sid__ == sid;
}
