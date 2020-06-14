defmodule SportHub.Db.TrackSegment do
  use Ecto.Schema

  schema "track_segments" do
    field :track_id, :integer

    belongs_to :tracks, SportHub.Db.Track
    has_many :track_points, SportHub.Db.TrackPoint
  end

  def changeset(track_segment, params \\ %{}) do
    track_segment
    |> Ecto.Changeset.cast(params, [])
    |> Ecto.Changeset.validate_required([])
    |> Ecto.Changeset.cast_assoc(:track_points, with: &SportHub.Db.TrackPoint.changeset/2)
  end
end
