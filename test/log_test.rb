require 'minitest/autorun'

require 'gitsearch'

describe Database do

  describe "#log" do

    it "inserts one repository id in a log" do
      logger = Log.new

      logger.log(["id1"])

      logged_id = nil
      line_count = 0

      File.open(logger.filename, "r") do |i|
        i.each_line { |line| logged_id = line.strip ; line_count += 1 }
      end

      assert_equal(logged_id, "id1")
      assert_equal(line_count, 1)
    end

    it "inserts multiple repository ids in a log" do
      logger = Log.new

      logger.log(["id1", "id2"])

      line_count = 0

      File.open(logger.filename, "r") do |i|
        i.each_line { |line| line_count += 1 }
      end

      assert_equal(line_count, 2)
    end

    it "inserts ids in a new log if no log id is specified" do
      # Since we are using SecureRandom, we will limit ourself to test two instances of Log

      logger1 = Log.new
      logger2 = Log.new

      logger1.log(["id1"])
      logger2.log(["id1"])

      line_count1 = 0
      line_count2 = 0

      File.open(logger1.filename, "r") do |i|
        i.each_line { |line| line_count1 += 1 }
      end

      File.open(logger2.filename, "r") do |i|
        i.each_line { |line| line_count2 += 1 }
      end

      assert_equal(line_count1, 1)
      assert_equal(line_count2, 1)
    end
  end

  describe "#each_repository_id" do
    it "yields all logged ids one by one" do
      logger = Log.new

      logger.log(["id1", "id2"])

      count = 1
      logger.each_repository_id { |id| assert_equal(id, "id#{count}") ; count += 1 }
    end

    it "has a silent behavior if no ids are found" do
      logger = Log.new

      logger.log([])

      logged_id = nil
      logger.each_repository_id { |id| logged_id = id }

      assert_nil logged_id
    end
  end
end
