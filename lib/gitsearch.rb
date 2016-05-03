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
end