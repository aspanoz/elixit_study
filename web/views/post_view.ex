defmodule AppPhoenix.PostView do
  @moduledoc '''
    web/views/post_view
  '''
  use AppPhoenix.Web, :view

  def markdown(body) do
    body
      |> Earmark.to_html
      |> raw
  end

  def render("scripts.html", assigns) do
    case assigns[:markdown] do
      true ->
        "<link rel='stylesheet' href='/css/simplemde.min.css'>
    <script src='/js/simplemde.min.js'></script>"
      _ ->
        ""
    end
  end

end
