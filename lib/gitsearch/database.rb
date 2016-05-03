require "pstore"

class Database
  DEFAULT_DATABASE_FILENAME = "database"
  EXTENTION = ".pstore"

  def initialize(filename=nil)
    @filename = (filename || DEFAULT_DATABASE_FILENAME) + EXTENTION
    @store = PStore.new(@filename)
  end

  # On assume que le format json est connu
  def batch_update(repositories)
    open do |store|
      repositories.each do |repository|
        id = repository[:id]

        store[id] = repository
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
    repo = nil
    open { |store| repo  = store[id] }

    repo
  end

  def batch_info(repository_ids)
    repos = []
    open do |store|
      repository_ids.each do |id|
        repos << store[id.to_sym]
      end
    end
    repos
  end

  def repositories_info()
    repos = []
    open do |store|
      store.roots().each do |repo|
      repos << store[repo]
      end
    end
    repos
  end

  private
  def open
    @store.transaction do
      yield(@store)

      @store.commit
    end
  end
end