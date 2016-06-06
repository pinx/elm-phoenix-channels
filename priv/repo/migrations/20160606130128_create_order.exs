defmodule Meep.Repo.Migrations.CreateOrder do
  use Ecto.Migration

  def change do
    create table(:orders) do
      add :qty, :integer

      timestamps
    end

  end
end
