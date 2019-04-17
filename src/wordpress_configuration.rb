def is_set(val)
  if val != ''
  elsif val.is_a?(Array)
  val.length != 0
end
end

class WordpressConfiguration
  attr_accessor :job_id
  attr_accessor :wordpress_scanner_target
  attr_accessor :wordpress_stealthy

  def self.from_target(job_id, target)
    config = WordpressConfiguration.new

    config.job_id = job_id
    config.wordpress_scanner_target = target.dig('location')
    config.wordpress_stealthy = '--stealthy' if target.dig('WP_STEALTHY') == 'true'
    config
  end
end
