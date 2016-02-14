"use script";

// module Main

exports.appendToBody =
  function(node) {
    return function() {
      document.body.appendChild(node);
      return {};
    };
  };
