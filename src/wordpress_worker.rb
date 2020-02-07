require 'json'
require 'ruby-scanner-scaffolding'

require_relative "./wordpress_configuration"

require_relative "./wordpress_scan"

class WordpressWorker < CamundaWorker
	attr_accessor :errored

	def initialize(camunda_url, topic, variables, task_lock_duration = 3600000, poll_interval = 5)
		super(camunda_url, topic, variables, task_lock_duration = 3600000, poll_interval = 5)

		@errored = false
	end

	def work(job_id, targets)
		configs = targets.map {|target|
			WordpressConfiguration.from_target job_id, target
		}

		scans = configs.map { |config|
			scan = WordpressScan.new(config)
			scan.start
			if scan.errored
				@errored = true
			end
			scan
		}

		{
				findings: scans.flat_map{|scan| scan.results},
				rawFindings: scans.map{|scan| scan.raw_results.to_json}.to_json,
				scannerId: @worker_id.to_s,
				scannerType: 'wordpress'
		}
	end

	def version
		if ENV.key? 'WPSCAN_VERSION'
			ENV["WPSCAN_VERSION"]
		else
			"unkown"
		end
	end
end
