def is_set(val)
  if val != ''
  elsif val.is_a?(Array)
  val.length != 0
end
end

class WordpressConfiguration
  attr_accessor :job_id
  attr_accessor :wordpress_scanner_target
  attr_accessor :wordpress_configuration

  def self.from_target(job_id, target)
    config = WordpressConfiguration.new

    enumerate = []
    target.dig('attributes', 'WP_ENUMERATE').each { |_, flag| enumerate << flag unless flag.nil?  } unless !target.dig('attributes', 'WP_ENUMERATE')

    config.job_id = job_id
    config.wordpress_scanner_target = target.dig('location')
    config.wordpress_configuration = ""
    config.wordpress_configuration += '--stealthy ' if target.dig('attributes', 'WP_STEALTHY')
    config.wordpress_configuration += "--enumerate #{enumerate.join(",")} " unless enumerate.empty?
    config.wordpress_configuration += "--max-scan-duration #{target.dig('attributes', 'WP_MAX_DURATION')} " unless !target.dig('attributes', 'WP_MAX_DURATION')
    config.wordpress_configuration += "--throttle #{target.dig('attributes', 'WP_THROTTLE')} " unless !target.dig('attributes', 'WP_THROTTLE')
    config.wordpress_configuration += "--request-timeout #{target.dig('attributes', 'WP_REQUEST_TIMEOUT')} " unless !target.dig('attributes', 'WP_REQUEST_TIMEOUT')
    config.wordpress_configuration += "--detection-mode #{target.dig('attributes', 'WP_DETECTION_MODE')} " unless !target.dig('attributes', 'WP_DETECTION_MODE')
    config.wordpress_configuration += "--ua #{target.dig('attributes', 'WP_USER_AGENT')} " unless !target.dig('attributes', 'WP_USER_AGENT')
    config.wordpress_configuration += "--headers #{target.dig('attributes', 'WP_HEADERS')} " unless !target.dig('attributes', 'WP_HEADERS')
    config.wordpress_configuration += "--api-token #{target.dig('attributes', 'WPVULNDB_API_TOKEN')} " unless !target.dig('attributes', 'WPVULNDB_API_TOKEN')


    config
  end
end
