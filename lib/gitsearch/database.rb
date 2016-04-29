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

  def delete(repository_id)
    open do |store|
      store.delete(repository_id)
    end
  end

  def batch_delete(repository_ids)
    open do |store|
      repository_ids.each do |id|
        store.delete(id)
      end
    end
  end

  def find_by(id)
    open { |store| store[:"#{id}"] }
  end

  private
  def open
    @store.transaction do
      yield(@store)

      @store.commit
    end
  end
end