defmodule Tunez.Music.Artist do
  @moduledoc """
  Represents a musical artist.
  """
  use Ash.Resource, otp_app: :tunez, domain: Tunez.Music, data_layer: AshPostgres.DataLayer

  postgres do
    table "artists"
    repo Tunez.Repo
  end
end
