defmodule SportHub.Import.GpxImportTest do
  use ExUnit.Case, async: true
  alias SportHub.Import.GpxImport
  alias SportHub.Db.Track
  alias SportHub.Db.TrackPoint
  alias SportHub.Db.TrackSegment

  setup do
    :ok = Ecto.Adapters.SQL.Sandbox.checkout(SportHub.Repo)
  end

  test "imports simple gpx" do
    %Track{
      name: "name",
      track_segments: [
        %TrackSegment{
          track_points: [
            %TrackPoint{
              latitude: 51.5,
              longitude: 8.5,
              elevation: 102.0,
              time: ~U[2020-06-07 07:00:05Z]
            },
            %TrackPoint{
              latitude: 51.6,
              longitude: 8.6,
              elevation: 102.2,
              time: ~U[2020-06-07 07:00:06Z]
            }
          ]
        }
      ]
    } =
      GpxImport.import(~S"""
      <gpx>
        <trk>
          <name>name</name>
          <trkseg>
            <trkpt lat="51.5" lon="8.5">
              <ele>102</ele>
              <time>2020-06-07T07:00:05.000Z</time>
            </trkpt>
            <trkpt lat="51.6" lon="8.6">
              <ele>102.2</ele>
              <time>2020-06-07T07:00:06.000Z</time>
            </trkpt>
          </trkseg>
        </trk>
      </gpx>
      """)
      |> SportHub.Repo.insert!()
  end

  @examples ["runME-garmin.gpx", "runME-strava-orig.gpx", "runME-strava.gpx"]
  for name <- @examples do
    test "#{name} parses and inserts" do
      File.read!(Path.join([__DIR__, "examples", "runME-garmin.gpx"]))
      |> GpxImport.import()
      |> SportHub.Repo.insert!()
    end
  end
end
