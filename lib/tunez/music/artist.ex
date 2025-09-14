defmodule Tunez.Music.Artist do
  @moduledoc """
  Represents a musical artist.
  """
  use Ash.Resource, otp_app: :tunez, domain: Tunez.Music, data_layer: AshPostgres.DataLayer

  postgres do
    table "artists"
    repo Tunez.Repo
  end

  actions do
    defaults [:create, :read, :destroy]
    default_accept [:name, :biography]

    update :update do
      require_atomic? false
      accept [:name, :biography]

      change fn changeset, _context ->
               new_name = Ash.Changeset.get_attribute(changeset, :name)
               previous_name = Ash.Changeset.get_data(changeset, :name)
               previous_names = Ash.Changeset.get_attribute(changeset, :previous_names) || []

               names =
                 [previous_name | previous_names]
                 |> Enum.uniq()
                 |> Enum.reject(fn name -> name == new_name end)

               Ash.Changeset.change_attribute(changeset, :previous_names, names)
             end,
             where: [changing(:name)]
    end
  end

  attributes do
    uuid_v7_primary_key :id

    attribute :name, :string, allow_nil?: false
    attribute :biography, :string
    attribute :previous_names, {:array, :string}, default: []

    create_timestamp :inserted_at
    update_timestamp :updated_at
  end

  relationships do
    has_many :albums, Tunez.Music.Album, sort: {:year_released, :desc}
  end
end
