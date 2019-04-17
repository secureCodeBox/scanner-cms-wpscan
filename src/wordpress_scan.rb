require 'securerandom'
require 'json'
require 'logger'
require 'pathname'

require_relative './wordpress_result_transformer'

$logger = Logger.new(STDOUT)

class ScanTimeOutError < StandardError

end

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
		begin
			start_scan
			$logger.info "Retrieving scan results for #{@config.wordpress_scanner_target}"
			get_scan_report
		rescue ScanTimeOutError
			$logger.warn "Scan timed out! Sending unfinished report to engine."
			get_scan_report(timed_out: true)
			@errored = true
		end
	end

	def start_scan
		begin
      resultsFile = File.open("/tmp/raw-results.txt", "w+")

			wordpressCommandLine = "wpscan --url #{@config.wordpress_scanner_target} -o #{Pathname.new(resultsFile)} #{@config.wordpress_stealthy}"

      resultsFile.write(`#{wordpressCommandLine}`)
      @raw_results = JSON.parse(resultsFile.read)
      File.delete(resultsFile)
    rescue => err
			$logger.warn err
			raise CamundaIncident.new("Failed to start Wordpress scan.", "This is most likely related to a error in the configuration. Check the SSH logs for more details.")
		end
	end

	def get_scan_report(timed_out: false)
		begin
			@results = @transformer.transform(@raw_results, timed_out: timed_out)
		rescue => err
			$logger.warn err
		end
	end
end
