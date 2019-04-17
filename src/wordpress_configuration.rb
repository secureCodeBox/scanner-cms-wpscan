def is_set(val)
  if val != ''
  elsif val.is_a?(Array)
  val.length != 0
end
end

class WordpressConfiguration
  attr_accessor :job_id
  attr_accessor :policies_directory
  attr_accessor :ssh_policy_file
  attr_accessor :ssh_timeout_seconds


  def self.from_target(job_id, target, policies_directory = "/securecodebox/static/")
    config = WordpressConfiguration.new

    config.policies_directory = policies_directory
    config.job_id = job_id
    config.ssh_policy_file = target.dig('attributes','SSH_POLICY_FILE')
    config.ssh_timeout_seconds = target.dig('attributes','SSH_TIMEOUT_SECONDS')
    config
  end

  def filePath
    template_file = Pathname.new(self.ssh_policy_file)

    "/#{policies_directory}/#{self.job_id}#{template_file.extname}"
  end
end
