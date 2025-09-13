defmodule Tunez.Music do
  @moduledoc """
  Represents the music domain, containing resources such as artists, albums, and tracks.
  """
  use Ash.Domain,
    otp_app: :tunez

  resources do
    resource Tunez.Music.Artist do
      define :create_artist, action: :create
      define :list_artists, action: :read
      define :get_artists_by_id, action: :read, get_by: :id
      define :update_artist, action: :update
      define :destroy_artist, action: :destroy
    end
  end
end
