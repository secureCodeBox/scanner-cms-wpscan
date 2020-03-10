require 'securerandom'
require 'json'
require 'logger'
require 'pathname'

require_relative './wordpress_result_transformer'

$logger = Logger.new(STDOUT)
$logger.level = ENV.key?('DEBUG') ? Logger::DEBUG : Logger::INFO

class WordpressScan
	attr_reader :raw_results
	attr_reader :results
	attr_reader :errored

	def initialize(config)
		@config = config
		@errored = false
		@transformer = WordpressResultTransformer.new
	end

	def start
		$logger.info "Running scan for #{@config.wordpress_scanner_target}"
		start_scan
		$logger.info "Retrieving scan results for #{@config.wordpress_scanner_target}"
		get_scan_report
	end

	def start_scan
		begin
			wordpressCommandLine = "wpscan --url #{@config.wordpress_scanner_target} -f json -o /tmp/raw-results.txt #{@config.wordpress_configuration}"
      `#{wordpressCommandLine}`

      resultsFile = File.open("/tmp/raw-results.txt", "r+")
      @raw_results = JSON.parse(resultsFile.read)
      File.delete(resultsFile)
    rescue => err
			$logger.warn err
			raise CamundaIncident.new("Failed to start Wordpress scan.", "This is most likely related to a error in the configuration. Check the WPScan logs for more details.")
		end
	end

	def get_scan_report
		begin
			@results = @transformer.transform(@raw_results)
		rescue => err
			$logger.warn err
		end
	end
end
