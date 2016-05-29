import {Socket} from "phoenix";

let socket = new Socket("/socket", {params: {token: window.userToken}});


socket.connect();

// For right now, just hardcode this to whatever post id you're working with
const postId = 4;
const channel = socket.channel(`comments:${postId}`, {});
channel.join()
  .receive("ok", resp => { console.log("Joined successfully", resp) })
  .receive("error", resp => { console.log("Unable to join", resp) });

export default socket;
