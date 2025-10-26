defmodule Tunez.Secrets do
  @moduledoc """
  Provides secrets for AshAuthentication.
  """
  use AshAuthentication.Secret

  def secret_for(
        [:authentication, :tokens, :signing_secret],
        Tunez.Accounts.User,
        _opts,
        _context
      ) do
    Application.fetch_env(:tunez, :token_signing_secret)
  end
end
