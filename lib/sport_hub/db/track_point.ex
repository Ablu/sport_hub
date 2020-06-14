defmodule SportHub.Db.TrackPoint do
  use Ecto.Schema

  schema "track_points" do
    field :latitude, :float
    field :longitude, :float
    field :elevation, :float
    field :time, :utc_datetime

    belongs_to :track_segment, SportHub.Db.TrackSegment
  end

  def changeset(track_point, params \\ %{}) do
    track_point
    |> Ecto.Changeset.cast(params, [:latitude, :longitude, :elevation, :time])
    |> Ecto.Changeset.validate_required([:latitude, :longitude, :elevation, :time])
  end
end
