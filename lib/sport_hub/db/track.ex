defmodule SportHub.Db.Track do
  use Ecto.Schema

  schema "tracks" do
    field :name, :string

    has_many :track_segments, SportHub.Db.TrackSegment
  end

  def changeset(track, params \\ %{}) do
    track
    |> Ecto.Changeset.cast(params, [:name])
    |> Ecto.Changeset.validate_required([:name])
    |> Ecto.Changeset.cast_assoc(:track_segments, with: &SportHub.Db.TrackSegment.changeset/2)
  end
end
