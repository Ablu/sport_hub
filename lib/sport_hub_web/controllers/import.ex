defmodule SportHubWeb.ImportController do
  use SportHubWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end

  def create(conn, %{"gpx" => %Plug.Upload{path: path}}) do
    File.read!(path)
    |> SportHub.Import.GpxImport.import()
    |> SportHub.Repo.insert!()
    render(conn, "done.html")
  end
end
