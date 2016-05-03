require 'minitest/autorun'

require 'gitsearch'

describe Database do
  before do
  end

  after do
    `rm TEST_DATABASE.pstore`
  end

  describe "#batch_update" do
    database_filename = "TEST_DATABASE"

    it "inserts one repository in the database" do
      repositories = [ {id: "id1", data: "some_data"} ]

      db = Database.new(database_filename)
      db.batch_update(repositories)

      repository = db.find_by("id1")

      refute_nil repository
    end

    it "inserts two repositories in the database since it's a batch update" do
      repositories = [ {id: "id1", data: "some_data"}, {id: "id2", data: "some_data"}]

      db = Database.new(database_filename)
      db.batch_update(repositories)

      repository1 = db.find_by("id1")
      repository2 = db.find_by("id2")

      refute_nil repository1
      refute_nil repository2
    end

    it "does not insert twice the same repository id in the database" do
      repositories = [ {id: "id1", data: "some_data"}, {id: "id1", data: "new_data"}]

      db = Database.new(database_filename)
      db.batch_update(repositories)

      repository1 = db.find_by("id1")

      refute_nil repository1
    end

    it "updates the database when the same id is recorded with the new data" do
      repositories = [ {id: "id1", data: "some_data"}, {id: "id1", data: "new_data"}]

      db = Database.new(database_filename)
      db.batch_update(repositories)

      repository1 = db.find_by("id1")
      refute_nil repository1

      assert_equal(repository1, {:id=>"id1", :data=>"new_data"})
    end
  end

  describe "#delete" do
    database_filename = "TEST_DATABASE"

    it "deletes the id from the database" do
      repositories = [{id: "id1", data: "some_data"}]

      db = Database.new(database_filename)
      db.batch_update(repositories)

      db.delete("id1")

      repository1 = db.find_by("id1")

      assert_nil repository1
    end

    it "only deletes the desired id from the database" do
      repositories = [{id: "id1", data: "some_data"}, {id: "id2", data: "some_data"}]

      db = Database.new(database_filename)
      db.batch_update(repositories)

      db.delete("id1")

      repository1 = db.find_by("id1")
      repository2 = db.find_by("id2")

      assert_nil repository1
      refute_nil repository2
    end

    it "has a silent behavior when the id is not found" do
      repositories = [{id: "id1", data: "some_data"}, {id: "id2", data: "some_data"}]

      db = Database.new(database_filename)
      db.batch_update(repositories)

      db.delete("id3")

      repository1 = db.find_by("id1")
      repository2 = db.find_by("id2")

      refute_nil repository1
      refute_nil repository2
    end
  end

  describe "#find_by" do
    database_filename = "TEST_DATABASE"

    it "finds the ids" do
      repositories = [{id: "id1", data: "some_data"}, {id: "id2", data: "some_data"}]

      db = Database.new(database_filename)
      db.batch_update(repositories)

      repository1 = db.find_by("id1")
      repository2 = db.find_by("id2")

      refute_nil repository1
      refute_nil repository2
    end

    it "has a silent behavior when the id is not found" do
      repositories = [{id: "id1", data: "some_data"}, {id: "id2", data: "some_data"}]

      db = Database.new(database_filename)
      db.batch_update(repositories)

      repository3 = db.find_by("id3")

      assert_nil repository3
    end
  end
end
