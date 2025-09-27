defmodule Tunez.Music.Artist do
  @moduledoc """
  Represents a musical artist.
  """
  use Ash.Resource,
    otp_app: :tunez,
    domain: Tunez.Music,
    data_layer: AshPostgres.DataLayer,
    extensions: [AshJsonApi.Resource]

  json_api do
    type "artist"
    includes [:albums]
    derive_filter? false
  end

  postgres do
    table "artists"
    repo Tunez.Repo

    custom_indexes do
      index "name gin_trgm_ops", name: "artists_name_gin_index", using: "GIN"
    end
  end

  resource do
    description "A person or a group who creates and releases music."
  end

  actions do
    defaults [:create, :read, :destroy]
    default_accept [:name, :biography]

    update :update do
      require_atomic? false
      accept [:name, :biography]

      change Tunez.Music.Changes.UpdatePreviousNames, where: [changing(:name)]
    end

    read :search do
      description "Lists artists, optionally filtered by name"
      pagination offset?: true, default_limit: 12

      argument :query, :ci_string do
        description "Return only artists with names including the given value (case insensitive)"
        constraints allow_empty?: true
        default ""
      end

      # adds condition to the query to filter by name containing the query
      filter expr(contains(name, ^arg(:query)))
    end
  end

  attributes do
    uuid_v7_primary_key :id

    attribute :name, :string, allow_nil?: false, public?: true
    attribute :biography, :string, public?: true
    attribute :previous_names, {:array, :string}, default: [], public?: true

    create_timestamp :inserted_at, public?: true
    update_timestamp :updated_at, public?: true
  end

  relationships do
    has_many :albums, Tunez.Music.Album, sort: {:year_released, :desc}, public?: true
  end

  calculations do
    # leaving these here for example of how calculations can be used compared to aggregates
    # calculate :album_count, :integer, expr(count(albums))
    # calculate :latest_album_year_released, :integer, expr(first(albums, field: :year_released))
    # calculate :cover_image_url, :string, expr(first(albums, field: :cover_image_url))
  end

  aggregates do
    count :album_count, :albums, public?: true
    first :latest_album_year_released, :albums, :year_released, public?: true
    first :cover_image_url, :albums, :cover_image_url
  end
end
