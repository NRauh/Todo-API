defmodule Todo.ItemView do
  use Todo.Web, :view

  def render("index.json", %{items: items}) do
    %{items: render_many(items, Todo.ItemView, "item.json")}
  end

  def render("show.json", %{item: item}) do
    %{item: render_one(item, Todo.ItemView, "item.json")}
  end

  def render("item.json", %{item: item}) do
    %{id: item.id,
      title: item.title,
      description: item.description,
      complete: item.complete,
      due_date: item.due_date}
  end
end
