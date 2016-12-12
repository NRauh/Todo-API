defmodule Todo.ItemChannel do
  use Todo.Web, :channel

  def join("item:lobby", payload, socket) do
    if authorized?(payload) do
      {:ok, socket}
    else
      {:error, %{reason: "unauthorized"}}
    end
  end

  def broadcast_item(item) do
    payload = %{
      "item" => %{
        "id" => item.id,
        "title" => item.title,
        "due_date" => item.due_date,
        "description" => item.description,
        "complete" => item.complete}}
    Todo.Endpoint.broadcast("item:lobby", "got_item", payload)
  end

  def remove_item(id) do
    Todo.Endpoint.broadcast("item:lobby", "remove_item", %{"id" => id})
  end

  def change_completion(id) do
    Todo.Endpoint.broadcast("item:lobby", "change_completion", %{"id" => id})
  end

  # Add authorization logic here as required.
  defp authorized?(_payload) do
    true
  end
end
