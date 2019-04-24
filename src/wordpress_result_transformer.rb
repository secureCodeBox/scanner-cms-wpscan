require 'securerandom'
require 'json'
require 'date'

class WordpressResultTransformer
  def initialize(uuid_provider = SecureRandom)
    @uuid_provider = uuid_provider;
    @findings = []
  end


  def transform(results, timed_out: false)
    results.each do |r|
      @findings << {
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
              # start_time: Time.at(r.dig('start_time')),
              # end_time: Time.at(r.dig('stop_time'))
          }
      }
      unless r.dig('version').nil? or r.dig('version').empty?
        vulnerabilitiesToFindings(r.dig('version', 'vulnerabilities')) unless r.dig('version', 'vulnerabilities').nil? or r.dig('version', 'vulnerabilities').empty?
      end
      if r.dig('main_theme','version').nil? or r.dig('main_theme','version').empty?
        vulnerabilitiesToFindings(r.dig('main_theme', 'vulnerabilities')) unless r.dig('main_theme', 'vulnerabilities').nil? or r.dig('main_theme', 'vulnerabilities').empty?
      else
        vulnerabilitiesToFindings(r.dig('main_theme', 'version', 'vulnerabilities')) unless r.dig('main_theme', 'version', 'vulnerabilities').nil? or r.dig('main_theme', 'version', 'vulnerabilities').empty?
      end
      unless r.dig('plugins').nil? or r.dig('plugins').empty?
        r.dig('plugins').each do |p|
            if p.dig('version').nil?
              vulnerabilitiesToFindings(p.dig('vulnerabilities')) unless p.dig('vulnerabilities').nil? or p.dig('vulnerabilities').empty?
            else
              vulnerabilitiesToFindings(p.dig('version', 'vulnerabilities')) unless p.dig('version', 'vulnerabilities').nil? or p.dig('version', 'vulnerabilities').empty?
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

  def vulnerabilitiesToFindings(vulnerabilityArray)
    vulnerabilityArray.each do |vA|
        @findings << {
          id: @uuid_provider.uuid,
          name: vA.dig('title').split('-')[0],
          description: vA.dig('title').split('-')[1],
          category: '',
          osi_layer: 'NETWORK',
          severity: 'INFORMATIONAL',
          reference: {},
          hint: '',
          location: '',
          attributes: {
              cve: vA.dig('references', 'cve'),
              ref_url: vA.dig('references', 'url'),
              wpvulndb: vA.dig('references', 'wpvulndb')
          }
        }
    end
  end
end