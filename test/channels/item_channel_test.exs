defmodule Todo.ItemChannelTest do
  use Todo.ChannelCase

  alias Todo.ItemChannel

  setup do
    {:ok, _, socket} =
      socket("user_id", %{some: :assign})
      |> subscribe_and_join(ItemChannel, "item:lobby")

    {:ok, socket: socket}
  end

  test "can broadcast item" do
    item = %{
      :id => 1,
      :title => "hello world",
      :due_date => "2017-01-02",
      :description => "say hi to the world",
      :complete => false}
    Todo.ItemChannel.broadcast_item(item)
    assert_broadcast "got_item", %{
      "item" => %{
        "id" => 1,
        "title" => "hello world",
        "due_date" => "2017-01-02",
        "description" => "say hi to the world",
        "complete" => false}}
  end

  test "can broadcast which should be removed" do
    Todo.ItemChannel.remove_item(1)
    assert_broadcast "remove_item", %{"id" => 1}
  end

  test "can broadcast which item should change it's completion" do
    Todo.ItemChannel.change_completion(1)
    assert_broadcast "change_completion", %{"id" => 1}
  end
end
