defmodule Todo.ItemChannel do
  use Todo.Web, :channel

  alias Todo.Item

  def join("item:lobby", payload, socket) do
    if authorized?(payload) do
      {:ok, socket}
    else
      {:error, %{reason: "unauthorized"}}
    end
  end

  def handle_in("new_item", %{"item" => item_params}, socket) do
    changeset = Item.changeset(%Item{}, item_params)

    case Repo.insert(changeset) do
      {:ok, item} ->
        IO.inspect item
        broadcast!(socket, "new_item", %{
          "item" => %{
            "id" => item.id,
            "title" => item.title,
            "due_date" => item.due_date,
            "description" => item.description,
            "complete" => item.complete}})
        {:noreply, socket}
      {:error, _changeset} ->
        {:error, %{reason: "Failed to add item"}}
    end
  end

  # Channels can be used in a request/response fashion
  # by sending replies to requests from the client
  def handle_in("ping", payload, socket) do
    {:reply, {:ok, payload}, socket}
  end

  # It is also common to receive messages from the client and
  # broadcast to everyone in the current topic (item:lobby).
  def handle_in("shout", payload, socket) do
    broadcast socket, "shout", payload
    {:noreply, socket}
  end

  # Add authorization logic here as required.
  defp authorized?(_payload) do
    true
  end
end
