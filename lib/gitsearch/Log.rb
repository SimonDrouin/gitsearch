class Log
  LOG_DIRECTORY_NAME = "logs"
  LOG_FILE_EXT = ".tp3Log"

  attr_reader :filename
  def initialize
    @id = SecureRandom.uuid
    @filename = File.join(LOG_DIRECTORY_NAME, @id + LOG_FILE_EXT)
  end

  def log_id(id)
    @id = id
    @filename = File.join(@id, LOG_FILE_EXT)
  end

  def log(ids)
    File.open(@filename, "w") do |o|
      ids.each { |id| o.puts id }
    end
  end

  def each_repository_id
    File.open(@filename, "r") do |i|
      i.each_line {|line| yield(line) }
    end
  end
end