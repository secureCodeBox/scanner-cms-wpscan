require 'test/unit'
require 'json'
require_relative '../src/wordpress_result_transformer'

class FakeUuidProvider
  def uuid
    '49bf7fd3-8512-4d73-a28f-608e493cd726'
  end
end

class SshResultTransformerTest < Test::Unit::TestCase

  def setup
    @transformer = WordpressResultTransformer.new(FakeUuidProvider.new)

    @test_result = <<EOM
[
  {
    "ssh_scan_version": "0.0.40",
    "ip": "127.0.0.1",
    "hostname": "localhost",
    "port": 22,
    "server_banner": "",
    "ssh_version": "unknown",
    "os": "unknown",
    "os_cpe": "o:unknown",
    "ssh_lib": "unknown",
    "ssh_lib_cpe": "a:unknown",
    "key_algorithms": [

    ],
    "encryption_algorithms_client_to_server": [

    ],
    "encryption_algorithms_server_to_client": [

    ],
    "mac_algorithms_client_to_server": [

    ],
    "mac_algorithms_server_to_client": [

    ],
    "compression_algorithms_client_to_server": [

    ],
    "compression_algorithms_server_to_client": [

    ],
    "languages_client_to_server": [

    ],
    "languages_server_to_client": [

    ],
    "auth_methods": [

    ],
    "keys": null,
    "duplicate_host_key_ips": [

    ],
    "compliance": {
    },
    "start_time": "2019-03-20 14:54:36 +0100",
    "end_time": "2019-03-20 14:54:41 +0100",
    "scan_duration_seconds": 5.138688
  }
]

EOM
  end

  def test_should_transform_a_empty_result_into_the_finding_format

    result = JSON.parse(@test_result)

    assert_equal(
        @transformer.transform(result),
        [{
            id: '49bf7fd3-8512-4d73-a28f-608e493cd726',
            name: 'SSH Compliance',
            description: 'SSH Compliance Information',
            category: 'SSH Service',
            osi_layer: 'NETWORK',
            severity: 'INFORMATIONAL',
            reference: {},
            hint: '',
            location: '127.0.0.1',
            attributes: {
                compliance_policy: nil,
                compliant: nil,
                grade: nil,
                start_time: '2019-03-20 14:54:36 +0100',
                end_time: '2019-03-20 14:54:41 +0100',
                scan_duration_seconds: 5.138688,
                references: nil
            }
        }]
    )
  end

  def test_add_a_timed_out_finding_when_optional_parameter_is_passed

    result = JSON.parse(@test_result)

    assert_equal(
        @transformer.transform(result, timed_out: true),
        [{
             id: "49bf7fd3-8512-4d73-a28f-608e493cd726",
             name: "SSH Scan timed out and could no be finished.",
             description: "SSH Scan didnt send any new requests for 5 minutes. This probably means that ssh_scan encountered some internal errors it could not handle.",
             osi_layer: 'NOT_APPLICABLE',
             severity: "MEDIUM",
             category: "ScanError",
             hint: "This could be related to a misconfiguration.",
             attributes: {}
         }]
    )
  end
end