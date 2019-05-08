require 'test/unit'
require 'json'
require_relative '../src/wordpress_result_transformer'

class FakeUuidProvider
  def uuid
    '49bf7fd3-8512-4d73-a28f-608e493cd726'
  end
end

class WordpressResultTransformerTest < Test::Unit::TestCase

  def setup
    @transformer = WordpressResultTransformer.new(FakeUuidProvider.new)

    @test_result = <<EOM
{  
  "banner": null,
  "db_update_started": null,
  "db_files_updated": null,
  "db_update_finished": null,
  "start_time":1553093676,
  "start_memory":44224512,
  "target_url":"127.0.0.1",
  "effective_url":"127.0.0.1",
  "interesting_findings": null,
  "version": null,
  "main_theme": null,
  "config_backups": null,
  "plugins": null,
  "stop_time":1553093681,
  "elapsed":11,
  "requests_done":482,
  "cached_requests":3,
  "data_sent":84214,
  "data_sent_humanised":"82.24 KB",
  "data_received":24845623,
  "data_received_humanised":"23.695 MB",
  "used_memory":199913472,
  "used_memory_humanised":"190.652 MB"
}

EOM
  end

  def test_should_transform_a_empty_result_into_the_finding_format

    result = JSON.parse(@test_result)

    assert_equal(
        @transformer.transform(result),
        [{
            id: '49bf7fd3-8512-4d73-a28f-608e493cd726',
            name: 'CMS Wordpress',
            description: 'CMS Wordpress Information',
            category: 'CMS Wordpress',
            osi_layer: 'NETWORK',
            severity: 'INFORMATIONAL',
            reference: {},
            hint: '',
            location: '127.0.0.1',
            attributes: {
                requests_done: "482",
                db_update_finished: "",
                version: "",
                start_time: '2019-03-20 15:54:36 +0100',
                end_time: '2019-03-20 15:54:41 +0100'
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
             name: "Wordpress Scan timed out and could no be finished.",
             description: "Wordpress Scan didnt send any new requests for 5 minutes. This probably means that wpscan encountered some internal errors it could not handle.",
             osi_layer: 'NOT_APPLICABLE',
             severity: "MEDIUM",
             category: "ScanError",
             hint: "This could be related to a misconfiguration.",
             attributes: {}
         }]
    )
  end
end