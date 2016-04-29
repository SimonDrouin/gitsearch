class Log
  LOG_DIRECTORY_NAME = "logs"
  LOG_FILE_EXT = ".tp3Log"

  def initialize
    log_id(SecureRandom.uuid)
  end

  def log_id(id)
    @id = id
    self
  end

  def log(ids)
    File.open(filename, "w") do |o|
      ids.each { |id| o.puts id }
    end
  end

  def each_repository_id
    File.open(filename, "r") do |i|
      i.each_line {|line| yield(line) }
    end
  end

  def filename
    File.join(LOG_DIRECTORY_NAME, @id + LOG_FILE_EXT)
  end
end