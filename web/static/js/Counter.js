import {Socket} from 'phoenix'

export default React.createClass({
  getInitialState: function(){
    return {
      value: 0
    }
  },

  componentDidMount: function(){
    // Setup websocket
    let socket = new Socket("/ws")
    socket.connect()
    let chan = socket.chan("stats:" + this.props.kind, {})
    chan.join().receive("ok", payload => { this.onNewVal(payload.val) })
    chan.on("new_val", payload => { this.onNewVal(payload.val) })
  },

  onNewVal: function(val){
    this.setState({
      value: val
    })
  },

  render: function(){
    return (
      <div className="counter__value">
        <h1>
          {this.state.value}
        </h1>
      </div>
    )
  }
});
