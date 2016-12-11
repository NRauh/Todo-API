defmodule Todo.ItemControllerTest do
  use Todo.ConnCase

  alias Todo.Item
  @valid_attrs %{
    complete: false,
    description: "Time to do that thing",
    due_date: "2017-01-08",
    title: "That thing"}
  @invalid_attrs %{}

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "index/2" do
    test "lists all entries on index", %{conn: conn} do
      conn = get conn, item_path(conn, :index)
      assert json_response(conn, 200)["items"] == []
    end
  end

  describe "create/2" do
    test "creates and renders resource when data is valid", %{conn: conn} do
      conn = post conn, item_path(conn, :create), item: @valid_attrs
      assert json_response(conn, 201)["item"]["id"]
      assert Repo.get_by(Item, @valid_attrs)
    end
 
    test "does not create resource and renders errors when data is invalid", %{conn: conn} do
      conn = post conn, item_path(conn, :create), item: @invalid_attrs
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "show/2" do
    test "shows chosen resource", %{conn: conn} do
      item = Repo.insert! %Item{}
      conn = get conn, item_path(conn, :show, item)
      assert json_response(conn, 200)["item"] == %{"id" => item.id,
        "title" => item.title,
        "description" => item.description,
        "complete" => item.complete,
        "due_date" => item.due_date}
    end

    test "renders page not found when id is nonexistent", %{conn: conn} do
      assert_error_sent 404, fn ->
        get conn, item_path(conn, :show, -1)
      end
    end
  end

  describe "update/2" do
    test "updates and renders chosen resource when data is valid", %{conn: conn} do
      item = Repo.insert! %Item{}
      conn = put conn, item_path(conn, :update, item), item: @valid_attrs
      assert json_response(conn, 200)["item"]["id"]
      assert Repo.get_by(Item, @valid_attrs)
    end

    test "does not update chosen resource and renders errors when data is invalid", %{conn: conn} do
      item = Repo.insert! %Item{}
      conn = put conn, item_path(conn, :update, item), item: @invalid_attrs
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "delete/2" do
    test "deletes chosen resource", %{conn: conn} do
      item = Repo.insert! %Item{}
      conn = delete conn, item_path(conn, :delete, item)
      assert response(conn, 204)
      refute Repo.get(Item, item.id)
    end
  end
end
