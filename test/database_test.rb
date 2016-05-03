require 'minitest/autorun'

require 'gitsearch'

describe Database do
  before do
    `rm TEST_DATABASE.pstore`
  end

  describe "#batch_update" do
    database_filename = "TEST_DATABASE.pstore"

    it "inserts one repository in the database" do
      repositories = [ {"id1": {"data": "some_data"}}]

      db = Database.new(database_filename)
      db.batch_update(repositories)

      repository = db.find_by("id1")

      refute_nil repository
    end

    it "inserts two repositories in the database since it's a batch update" do
      repositories = [ {"id1": {"data": "some_data"}}, {"id2": {"data": "some_data"}}]

      db = Database.new(database_filename)
      db.batch_update(repositories)

      repository1 = db.find_by("id1")
      repository2 = db.find_by("id2")

      refute_nil repository1
      refute_nil repository2
    end

    it "does not insert twice the same repository id in the database" do
      repositories = [ {"id1": {"data": "some_data"}}, {"id1": {"data": "some_data"}}]

      db = Database.new(database_filename)
      db.batch_update(repositories)

      repository1 = db.find_by("id1")
      repository2 = db.find_by("id2")

      refute_nil repository1
      puts repository2
      assert_nil repository2
    end
  end
end
