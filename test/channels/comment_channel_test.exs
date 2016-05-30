defmodule AppPhoenix.CommentChannelTest do
  use AppPhoenix.ChannelCase

  alias AppPhoenix.CommentChannel
  alias AppPhoenix.MyDebuger

  setup do
    {:ok, _, socket} =
      # %{id: "user_id", assigns: %{some: :assign}}
      # |> socket()

    socket("user_id", %{some: :assign})
      |> MyDebuger.echo_bypass
      |> subscribe_and_join(CommentChannel, "comments:lobby")
    {:ok, socket: socket}
  end

  @tag :channel_comment
  test "ping replies with status ok", %{socket: socket} do
    ref = push socket, "ping", %{"hello" => "there"}
    assert_reply ref, :ok, %{"hello" => "there"}
  end

  @tag :channel_comment
  test "shout broadcasts to comments:lobby", %{socket: socket} do
    push socket, "shout", %{"hello" => "all"}
    assert_broadcast "shout", %{"hello" => "all"}
  end

  @tag :channel_comment
  test "broadcasts are pushed to the client", %{socket: socket} do
    broadcast_from! socket, "broadcast", %{"some" => "data"}
    assert_push "broadcast", %{"some" => "data"}
  end
end
