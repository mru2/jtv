import {Socket} from "phoenix"

let App = {
  $input: $('#input'),
  $messages: $('#messages'),

  start: function() {
    // Setup websocket
    let socket = new Socket("/ws")
    socket.connect()
    let chan = socket.chan("stats:flux", {})

    chan.join().receive("ok", payload => { this.onBootstrap(payload.body) })
    chan.on("new_msg", payload => { this.onMessage(payload.body) })

    // Setup DOM
    this.$input.on("keypress", event => {
      if( event.keyCode === 13 ){
        chan.push("new_msg", {body: this.$input.val()})
        this.$input.val("");
      }
    })
  },

  onBootstrap: function(messages) {
    _.each(messages, message => this.onMessage(message))
  },

  onMessage: function(text) {
    this.$messages.append(`<p>[${Date()}] ${text}</p>`)
  }
}

App.start();

export default App
