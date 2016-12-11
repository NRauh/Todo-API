defmodule Todo.ItemChannelTest do
  use Todo.ChannelCase

  alias Todo.ItemChannel

  setup do
    {:ok, _, socket} =
      socket("user_id", %{some: :assign})
      |> subscribe_and_join(ItemChannel, "item:lobby")

    {:ok, socket: socket}
  end

  test "adds new items", %{socket: socket} do

    push socket, "new_item", %{
      "item" => %{
        "title" => "Hello World",
        "due_date" => "2017-01-02",
        "description" => "A thing",
        "complete" => false}}
    assert_broadcast "new_item", %{
      "item" => %{
        "title" => "Hello World",
        "due_date" => "2017-01-02",
        "description" => "A thing",
        "complete" => false}}
    assert Repo.get_by(Todo.Item, title: "Hello World")
  end

  test "ping replies with status ok", %{socket: socket} do
    ref = push socket, "ping", %{"hello" => "there"}
    assert_reply ref, :ok, %{"hello" => "there"}
  end

  test "shout broadcasts to item:lobby", %{socket: socket} do
    push socket, "shout", %{"hello" => "all"}
    assert_broadcast "shout", %{"hello" => "all"}
  end

  test "broadcasts are pushed to the client", %{socket: socket} do
    broadcast_from! socket, "broadcast", %{"some" => "data"}
    assert_push "broadcast", %{"some" => "data"}
  end
end
