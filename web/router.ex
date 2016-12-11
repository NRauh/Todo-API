defmodule Todo.Router do
  use Todo.Web, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/api", Todo do
    pipe_through :api

    resources "/items", ItemController, except: [:new, :edit]
  end
end
