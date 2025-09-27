defmodule TunezWeb.AshJsonApiRouter do
  @moduledoc false
  use AshJsonApi.Router,
    domains: [Tunez.Music],
    open_api: "/open_api"
end
