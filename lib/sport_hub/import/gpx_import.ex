defmodule SportHub.Import.GpxImport do
  alias SportHub.Db.Track

  import Record
  defrecord(:xmlElement, extract(:xmlElement, from_lib: "xmerl/include/xmerl.hrl"))
  defrecord(:xmlAttribute, extract(:xmlAttribute, from_lib: "xmerl/include/xmerl.hrl"))
  defrecord(:xmlText, extract(:xmlText, from_lib: "xmerl/include/xmerl.hrl"))

  defp get_childs_of_name(element, name) do
    Enum.filter(xmlElement(element, :content), fn child ->
      Record.is_record(child, :xmlElement) && xmlElement(child, :name) == name
    end)
  end

  defp get_attrs([]), do: []

  defp get_attrs([attr | rest]) do
    [{xmlAttribute(attr, :name), xmlAttribute(attr, :value)} | get_attrs(rest)]
  end

  defp get_text_node_content(parent_node, text_node_name) do
    [child_node] = get_childs_of_name(parent_node, text_node_name)
    [child_text_node] = xmlElement(child_node, :content)
    to_string(xmlText(child_text_node, :value))
  end

  defp parse_track(track) do
    %Track{}
    |> Track.changeset(%{
      name: get_text_node_content(track, :name),
      track_segments: Enum.map(get_childs_of_name(track, :trkseg), &parse_track_segment/1)
    })
  end

  defp parse_track_segment(track_segment) do
    %{
      track_points: Enum.map(get_childs_of_name(track_segment, :trkpt), &parse_track_point/1)
    }
  end

  defp parse_track_point(track_point) do
    attrs = get_attrs(xmlElement(track_point, :attributes))
    {lat, ""} = Float.parse(to_string(Keyword.fetch!(attrs, :lat)))
    {lon, ""} = Float.parse(to_string(Keyword.fetch!(attrs, :lon)))
    {elevation, ""} = Float.parse(get_text_node_content(track_point, :ele))
    {:ok, time, 0} = DateTime.from_iso8601(get_text_node_content(track_point, :time))

    %{
      latitude: lat,
      longitude: lon,
      elevation: elevation,
      time: time
    }
  end

  def import(gpx) do
    {doc, []} =
      gpx
      |> :binary.bin_to_list()
      |> :xmerl_scan.string()

    [track] = get_childs_of_name(doc, :trk)
    parse_track(track)
  end
end
