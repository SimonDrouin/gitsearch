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

  def self.list(repository_ids, log=nil, verbose=nil, language=nil, description=nil)
    db = Database.new

    repos = db.batch_info(repository_ids) if repository_ids

    if log
      puts "Fetching repositories from log: #{log}" if verbose
      logger = Log.new(log)

      repos.merge(db.batch_info(logger.ids))
    end

    if language then
      puts "Filtering repositories by language: #{language}" if verbose
      repos = filter_by_lang(repos, language)
    end

    repos = db.all if repos.empty? && repository_ids.empty? && log.nil?
    repos.each do |repo|
      if repo then
        puts "----------" + "\n"
        puts "Name: #{repo["name"]}" + "\n"
        puts "Github URL: #{repo["html_url"]}" + "\n"
        puts "External Repository id: #{repo["id"]}"
        puts wrap("Description: #{repo["description"]}") if description
      end
    end
  end

  def self.filter_by_lang(repositories, language)
    repositories.select {|repo| repo["language"] && repo["language"].downcase == language.downcase}
  end
end