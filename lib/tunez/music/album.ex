defmodule Tunez.Music.Album do
  @moduledoc """
  Represents a music album.
  """
  use Ash.Resource, otp_app: :tunez, domain: Tunez.Music, data_layer: AshPostgres.DataLayer

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

  attributes do
    uuid_v7_primary_key :id

    attribute :name, :string, allow_nil?: false
    attribute :year_released, :integer, allow_nil?: false
    attribute :cover_image_url, :string

    create_timestamp :inserted_at
    update_timestamp :updated_at
  end

  relationships do
    belongs_to :artist, Tunez.Music.Artist, allow_nil?: false
  end
end
