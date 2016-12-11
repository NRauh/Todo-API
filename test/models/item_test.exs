defmodule Todo.ItemTest do
  use Todo.ModelCase

  alias Todo.Item

  @valid_attrs %{
    complete: false,
    description: "The description to an item",
    due_date: "2016-12-28",
    title: "Do a thing"}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = Item.changeset(%Item{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = Item.changeset(%Item{}, @invalid_attrs)
    refute changeset.valid?
  end
end
