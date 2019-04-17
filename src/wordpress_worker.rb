require 'json'

require_relative "../lib/camunda_worker"
require_relative "./rdpress_configuration"

require_relative "./rdpress_scan"

class WordpressWorker < CamundaWorker
	attr_accessor :errored

	def initialize(camunda_url, topic, variables, task_lock_duration = 3600000, poll_interval = 5)
		super(camunda_url, topic, variables, task_lock_duration = 3600000, poll_interval = 5)

		@errored = false
	end

	def work(job_id, targets)
		locations = targets.map {|target|
			target.dig('location')
		}
		config = WordpressConfiguration.from_target(job_id, targets.first)

		targetFile = File.open("/tmp/targets-of-#{job_id}.txt", "w+")
		targetFile.puts locations
		targetFile.close

		scan = SshScan.new(targetFile, config)
		scan.start
		if scan.errored
			@errored = true
		end
		scan

		{
				findings: scan.results,
				rawFindings: scan.raw_results.to_json,
				scannerId: @worker_id.to_s,
				scannerType: 'ssh'
		}
	end
end
