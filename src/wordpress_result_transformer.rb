require 'securerandom'
require 'json'
require 'date'

class WordpressResultTransformer
  def initialize(uuid_provider = SecureRandom)
    @uuid_provider = uuid_provider;
  end


  def transform(results, timed_out: false)
    findings = []
    results.each do |r|
      findings << {
          id: @uuid_provider.uuid,
          name: 'CMS Wordpress',
          description: 'CMS Wordpress Information',
          category: 'CMS Wordpress',
          osi_layer: 'NETWORK',
          severity: 'INFORMATIONAL',
          reference: {},
          hint: '',
          location: r.dig('target_url'),
          attributes: {
              start_time: DateTime.strptime("#{r.dig('start_time')}",'%s'),
              end_time: DateTime.strptime("#{r.dig('stop_time')}",'%s')
          }
      }

      unless r.dig('interesting_findings').nil? # interesting_findings oder vulnerabilities in version? And what is main_theme?
        r.dig('interesting_findings').each do |f|
          findings << {
              id: @uuid_provider.uuid,
              name: '',
              description: '',
              category: '',
              osi_layer: 'NETWORK',
              severity: 'INFORMATIONAL',
              reference: {},
              hint: '',
              location: '',
              attributes: {}
          }
        end
      end
    end

    if timed_out
      findings = [{
       id: @uuid_provider.uuid,
       name: "Wordpress Scan timed out and could no be finished.",
       description: "Wordpress Scan didnt send any new requests for 5 minutes. This probably means that wpscan encountered some internal errors it could not handle.",
       osi_layer: 'NOT_APPLICABLE',
       severity: "MEDIUM",
       category: "ScanError",
       hint: "This could be related to a misconfiguration.",
       attributes: {}
       }]
    end

    findings
  end
end