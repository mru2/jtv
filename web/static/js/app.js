import Counter from './Counter'

let App = {
  start: function() {
    _.each(this.counters(), this.createCounter.bind(this));
  },

  counters: function() {
    return document.querySelectorAll('.counter');
  },

  createCounter: function(el) {
    console.log('Creating counter on', el);
    var kind = el.getAttribute('data-kind');
    React.render(React.createElement(Counter, {kind: kind}), el);
  }
}

App.start();

export default App
