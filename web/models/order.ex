defmodule Meep.Order do
  use Meep.Web, :model

  schema "orders" do
    field :qty, :integer

    timestamps
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:qty])
    |> validate_required([:qty])
  end
end
