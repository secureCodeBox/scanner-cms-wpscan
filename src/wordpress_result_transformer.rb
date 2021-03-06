require 'securerandom'
require 'json'
require 'date'

class WordpressResultTransformer
  def initialize(uuid_provider = SecureRandom)
    @uuid_provider = uuid_provider;
  end


  def transform(r, timed_out: false)
    @findings = []

    @findings << {
        id: @uuid_provider.uuid,
        name: 'CMS Wordpress',
        description: 'CMS Wordpress Information',
        category: 'CMS Wordpress',
        osi_layer: 'APPLICATION',
        severity: 'INFORMATIONAL',
        reference: {},
        hint: '',
        location: r.dig('target_url'),
        attributes: {
            requests_done: r.dig('requests_done').to_s,
            db_update_finished: r.dig('db_update_finished').to_s,
            version: r.dig('version', 'number').to_s,
            start_time: r.dig('start_time').nil? ? nil : Time.at(r.dig('start_time')),
            end_time: r.dig('stop_time').nil? ? nil : Time.at(r.dig('stop_time'))
        }
    }
    unless r.dig('version').nil? or r.dig('version').empty?
      vulnerabilitiesToFindings(r.dig('version', 'vulnerabilities'), 'HIGH', 'Core') unless r.dig('version', 'vulnerabilities').nil? or r.dig('version', 'vulnerabilities').empty?
    end
    vulnerabilitiesToFindings(r.dig('main_theme', 'vulnerabilities'), r.dig('main_theme', 'version').nil? ? 'LOW' : 'HIGH', 'Theme') unless r.dig('main_theme', 'vulnerabilities').nil? or r.dig('main_theme', 'vulnerabilities').empty?

    unless r.dig('plugins').nil? or r.dig('plugins').empty?
      r.dig('plugins').each do |p|
            vulnerabilitiesToFindings(p[1].dig('vulnerabilities'), r.dig('main_theme', 'version').nil? ? 'LOW' : 'HIGH', 'Plugin') unless p[1].dig('vulnerabilities').nil? or p[1].dig('vulnerabilities').empty?
      end
    end

    @findings
  end

  def vulnerabilitiesToFindings(vulnerabilityArray, severity, category)
    vulnerabilityArray.each do |vA|
        @findings << {
          id: @uuid_provider.uuid,
          name: vA.dig('title').split('-')[0].strip,
          description: vA.dig('title').split('-')[1].strip,
          category: category,
          osi_layer: 'APPLICATION',
          severity: severity,
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