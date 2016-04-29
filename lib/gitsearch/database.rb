require "pstore"

class Database
  DEFAULT_DATABASE_FILENAME = "database.pstore"

  def initialize(filename: nil)
    @filename = filename || DEFAULT_DATABASE_FILENAME
    @store = PStore.new(@filename)
  end

  # On assume que le format json est connu
  def batch_update(repositories)

    open do |store|
      repositories.each do |repository|
        id = repository["id"]

        store[:"#{id}"] = repository
      end
    end
  end

  def find_by(id)
    open do |store|
      puts store[:"#{id}"]
    end
  end

  private
  def open
    @store.transaction do
      yield(@store)

      @store.commit
    end
  end
end