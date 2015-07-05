import {Socket} from "phoenix"

let App = {
  $input: $('#input'),
  $messages: $('#messages'),

  start: function() {
    // Setup websocket
    let socket = new Socket("/ws")
    socket.connect()
    let chan = socket.chan("stats:all_visits", {})

    chan.join().receive("ok", payload => { this.onBootstrap(payload.val) })
    chan.on("new_val", payload => { this.onMessage(payload.val) })
    //
    // // Setup DOM
    // this.$input.on("keypress", event => {
    //   if( event.keyCode === 13 ){
    //     chan.push("new_msg", {body: this.$input.val()})
    //     this.$input.val("");
    //   }
    // })
  },

  onBootstrap: function(val) {
    this.$messages.html('')
    this.onMessage(val)
  },

  onMessage: function(text) {
    this.$messages.html(`<p>[${Date()}] ${text}</p>`)
  }
}

App.start();

export default App
