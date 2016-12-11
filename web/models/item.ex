defmodule Todo.Item do
  use Todo.Web, :model

  schema "items" do
    field :title, :string
    field :description, :string
    field :complete, :boolean, default: false
    field :due_date, :string

    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:title, :description, :complete, :due_date])
    |> validate_required([:title, :description, :complete, :due_date])
  end
end
