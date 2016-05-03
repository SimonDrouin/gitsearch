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

  def self.list_by_ids(ids= nil)
    
    unless ids
        log = Log.new.log_id(options[:log])
        ids = log.ids
    end

    db.batch_info(ids.map {|id| id.to_sym})
  end

  def self.list_all()
    db.repositories_info()
  end

  def self.filter_by_lang(repositories, language)
    repositories.select {|repo| repo["language"] && repo["language"].downcase == language.downcase}
  end
end