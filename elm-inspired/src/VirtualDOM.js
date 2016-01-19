"use strict";

// module VirtualDOM

exports.vnode = function(tag) {
  var VNode = require('virtual-dom/vnode/vnode');
  return function(attrs) {
    return function(children) {
      return new VNode(tag, attrs, children);
    }
  }
}

exports.snode = function(tag) {
  var snode = require('virtual-dom/virtual-hyperscript/svg');
  return function(attrs) {
    return function(children) {
      return snode(tag, attrs, children);
    }
  }
}

exports.vtext = function(text) {
  var VText = require('virtual-dom/vnode/vtext');
  return new VText(text);
}

exports.diff = function(previous) {
  var diff = require('virtual-dom/diff');
  return function(current) {
    return diff(previous, current);
  }
}

exports.patch = function(domNode) {
  var patch = require('virtual-dom/patch');
  return function(patches) {
    return function() {
      return patch(domNode, patches);
    }
  }
}

exports.createElement = function(node) {
  var createElement = require('virtual-dom/create-element');
  return function() {
    return createElement(node);
  }
}
