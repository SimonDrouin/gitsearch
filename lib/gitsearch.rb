require 'gitsearch/version.rb'
require 'gitsearch/repository_finder'
require 'gitsearch/database'
require 'gitsearch/Log'

module Gitsearch

  def self.search(query, language, verbose)
    finder = RepositoryFinder.new
    repositories = finder.search(query, language)

    puts "updating #{repositories.size} in database #{@filename}" if verbose
    db = Database.new
    db.batch_update(repositories)

    logger = Log.new
    puts "logging query in #{logger.filename}" if verbose
    logger.log(repositories.map{|r| r["id"]})
  end

  def self.delete(repository_ids, log=nil)
    raise "there must be at least one repository id or log id" unless !repository_ids.empty? || log

    db = Database.new
    puts "YOOO #{repository_ids}"
    db.batch_delete(repository_ids)

    if log then
      logger = Log.new.log_id(log)
      logger.each_repository_id do |id|
        db.delete(id)
      end

      `rm #{logger.filename}`
    end
  end

  def self.list_by_ids(ids= nil)
    db = Database.new

    unless ids
        log = Log.new.log_id(options[:log])
        ids = log.ids
    end

    db.batch_info(ids.map {|id| id.to_sym})
  end

  def self.list_all()
    db = Database.new
    db.repositories_info()
  end

  def self.filter_by_lang(repositories, language)
    repositories.select {|repo| repo["language"] && repo["language"].downcase == language.downcase}
  end
end