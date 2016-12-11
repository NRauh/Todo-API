defmodule Todo.Repo.Migrations.CreateItem do
  use Ecto.Migration

  def change do
    create table(:items) do
      add :title, :text
      add :description, :text
      add :complete, :boolean, default: false, null: false
      add :due_date, :string

      timestamps()
    end

  end
end
