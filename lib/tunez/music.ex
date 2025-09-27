defmodule Tunez.Music do
  @moduledoc """
  Represents the music domain, containing resources such as artists, albums, and tracks.
  """
  use Ash.Domain,
    otp_app: :tunez,
    extensions: [AshGraphql.Domain, AshJsonApi.Domain, AshPhoenix]

  graphql do
    queries do
      get Tunez.Music.Artist, :get_artist_by_id, :read
      list Tunez.Music.Artist, :search_artists, :search
    end

    mutations do
      create Tunez.Music.Artist, :create_artist, :create
      update Tunez.Music.Artist, :update_artist, :update
      destroy Tunez.Music.Artist, :destroy_artist, :destroy
    end
  end

  json_api do
    routes do
      base_route "/artists", Tunez.Music.Artist do
        get :read
        index :search
        related :albums, :read, primary?: true
        post :create
        patch :update
        delete :destroy
      end

      base_route "/albums", Tunez.Music.Album do
        post :create
        patch :update
        delete :destroy
      end
    end
  end

  resources do
    resource Tunez.Music.Artist do
      define :create_artist, action: :create
      define :list_artists, action: :read
      define :get_artist_by_id, action: :read, get_by: :id
      define :update_artist, action: :update
      define :destroy_artist, action: :destroy

      define :search_artists,
        action: :search,
        args: [:query],
        default_options: [
          load: [:cover_image_url, :album_count, :latest_album_year_released]
        ]
    end

    resource Tunez.Music.Album do
      define :create_album, action: :create
      define :list_albums, action: :read
      define :get_album_by_id, action: :read, get_by: :id
      define :update_album, action: :update
      define :destroy_album, action: :destroy
    end

    forms do
      form :create_album, args: [:artist_id]
    end
  end
end
