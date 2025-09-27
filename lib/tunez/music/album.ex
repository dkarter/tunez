defmodule Tunez.Music.Album do
  @moduledoc """
  Represents a music album.
  """
  use Ash.Resource,
    otp_app: :tunez,
    domain: Tunez.Music,
    data_layer: AshPostgres.DataLayer,
    extensions: [AshGraphql.Resource, AshJsonApi.Resource]

  graphql do
    type :album
  end

  json_api do
    type "album"
  end

  postgres do
    table "albums"
    repo Tunez.Repo

    references do
      reference :artist, index?: true, on_delete: :delete
    end
  end

  actions do
    defaults [:read, :destroy]

    create :create do
      accept [:name, :year_released, :cover_image_url, :artist_id]
    end

    update :update do
      accept [:name, :year_released, :cover_image_url]
    end
  end

  validations do
    validate numericality(:year_released,
               greater_than_or_equal_to: 1900,
               less_than_or_equal_to: &__MODULE__.next_year/0
             ),
             where: [present(:year_released)],
             message: "must be between 1900 and next year"

    validate match(:cover_image_url, ~r/^https?:\/\/[^\s]+$/),
      where: [changing(:cover_image_url)],
      message: "must be a valid URL starting with http:// or https://"
  end

  attributes do
    uuid_v7_primary_key :id

    attribute :name, :string, allow_nil?: false, public?: true
    attribute :year_released, :integer, allow_nil?: false, public?: true
    attribute :cover_image_url, :string, public?: true

    create_timestamp :inserted_at
    update_timestamp :updated_at
  end

  relationships do
    belongs_to :artist, Tunez.Music.Artist, allow_nil?: false
  end

  def next_year do
    Date.utc_today().year + 1
  end

  calculations do
    calculate :years_ago, :integer, expr(2025 - year_released)

    calculate :years_ago_str,
              :string,
              expr("wow, this was released " <> years_ago <> " years ago!")
  end

  identities do
    identity :unique_album_per_artist, [:name, :artist_id]
  end
end
