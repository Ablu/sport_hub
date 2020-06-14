defmodule SportHub.Repo.Migrations.InitialActivityStructure do
  use Ecto.Migration

  def change do
    create table(:tracks) do
      add :name, :string
    end

    create table(:track_segments) do
      add :track_id, references(:tracks)
    end

    create table(:track_points) do
      add :track_segment_id, references(:track_segments)
      add :latitude, :float
      add :longitude, :float
      add :elevation, :float
      add :time, :utc_datetime
    end
  end
end
