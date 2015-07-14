require 'logger'

module SpreeMagentoImporter
  Logger = ::Logger.new(STDOUT).tap do |logger|
    logger.formatter = proc { |_severity, _datetime, _progname, msg| "#{msg}\n" }
  end
end
