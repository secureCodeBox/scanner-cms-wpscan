require 'securerandom'
require 'json'

class WordpressResultTransformer
  def initialize(uuid_provider = SecureRandom)
    @uuid_provider = uuid_provider;
  end


  def transform(results, timed_out: false)
    findings = []
    results.each do |r|
      findings << {
          id: @uuid_provider.uuid,
          name: 'SSH Compliance',
          description: 'SSH Compliance Information',
          category: 'SSH Service',
          osi_layer: 'NETWORK',
          severity: 'INFORMATIONAL',
          reference: {},
          hint: '',
          location: r.dig('ip'),
          attributes: {
              compliance_policy: r.dig('compliance', 'policy'),
              compliant: r.dig('compliance', 'compliant'),
              grade: r.dig('compliance', 'grade'),
              start_time: r.dig('start_time'),
              end_time: r.dig('end_time'),
              scan_duration_seconds: r.dig('scan_duration_seconds'),
              references: r.dig('compliance', 'references')
          }
      }

      unless r.dig('compliance', 'recommendations').nil?
        r.dig('compliance', 'recommendations').each do |f|
          findings << {
              id: @uuid_provider.uuid,
              name: f.split(':')[0],
              description: f.split(':')[1],
              category: 'SSH Service',
              osi_layer: 'NETWORK',
              severity: 'LOW',
              reference: {},
              hint: '',
              location: r.dig('ip'),
              attributes: {}
          }
        end
      end
    end

    if timed_out
      findings = [{
       id: @uuid_provider.uuid,
       name: "SSH Scan timed out and could no be finished.",
       description: "SSH Scan didnt send any new requests for 5 minutes. This probably means that ssh_scan encountered some internal errors it could not handle.",
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