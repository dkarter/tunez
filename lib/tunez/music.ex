defmodule Tunez.Music do
  @moduledoc """
  Represents the music domain, containing resources such as artists, albums, and tracks.
  """
  use Ash.Domain,
    otp_app: :tunez

  resources do
    resource Tunez.Music.Artist
  end
end
