require 'test/unit'
require_relative '../src/wordpress_configuration'

class WordpressConfigurationTest < Test::Unit::TestCase

  def test_should_build_a_correct_payload_with_minimal_input
    target = {
        "location" => 'localhost.com',
        "name" => 'unused',
        "attributes" => {
            "WP_STEALTHY" => false,
            "WP_ENUMERATE" => {"plugins" => nil, "themes" =>nil, "timthumbs" => nil, "configBackups" => nil, "dbExports" => nil, "userIDs" => nil, "mediaIDs" => nil},
            "WP_MAX_DURATION" => nil,
            "WP_THROTTLE" => nil,
            "WP_REQUEST_TIMEOUT" => nil,
            "WP_DETECTION_MODE" => nil,
            "WP_USER_AGENT" => nil,
            "WP_HEADERS" => nil
        }
    }
    config = WordpressConfiguration.from_target "49bf7fd3-8512-4d73-a28f-608e493cd726", target

    assert_equal(
        config.wordpress_configuration,
        ""
    )
  end

  def test_should_build_a_correct_payload_with_enumerate_set
    target = {
        "location" => 'localhost.com',
        "name" => 'unused',
        "attributes" => {
            "WP_STEALTHY" => false,
            "WP_ENUMERATE" => {"plugins" => "vp", "themes" => "vt", "timthumbs" => "tt", "configBackups" => "cb", "dbExports" => "dbe", "userIDs" => "u1-10", "mediaIDs" => "m1-100"},
            "WP_MAX_DURATION" => nil,
            "WP_THROTTLE" => nil,
            "WP_REQUEST_TIMEOUT" => nil,
            "WP_DETECTION_MODE" => nil,
            "WP_USER_AGENT" => nil,
            "WP_HEADERS" => nil
        }
    }
    config = WordpressConfiguration.from_target "49bf7fd3-8512-4d73-a28f-608e493cd726", target

    assert_equal(
        config.wordpress_configuration,
        "--enumerate vp,vt,tt,cb,dbe,u1-10,m1-100 "
    )
  end
end