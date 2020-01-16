---
title: 'WPScan'
path: 'scanner/WPScan'
category: 'scanner'
usecase: 'Wordpress Vulnerability Scanner'
release: 'https://img.shields.io/github/release/secureCodeBox/scanner-cms-wpscan.svg'
---

![WPScan Logo](https://raw.githubusercontent.com/wpscanteam/wpscan/gh-pages/images/wpscan_logo.png)

WPScan is a free, for non-commercial use, black box WordPress vulnerability scanner written for security professionals and blog maintainers to test the security of their sites.

> NOTE: You need to provide WPSan with an API Token so that it can look up vulnerabilities infos with https://wpvulndb.com. Without the token WPScan will only identify Wordpress Core / Plugin / Theme versions but not if they are actually vulnerable. You can get a free API Token at by registering for an account at https://wpvulndb.com. Using the secureCodeBox WPScans you can specify the token via the `WPVULNDB_API_TOKEN` target attribute, see the example below.

<!-- end -->

# About

This repository contains a self contained µService utilizing the WPScan scanner for the secureCodeBox project. To learn more about the WPScan scanner itself visit [wpscan.org] or [wpscan.io].

## WPScan parameters

To hand over supported parameters through api usage, you can set following attributes:

```json
[
  {
    "name": "some Name",
    "context": "some Context",
    "target": {
      "name": "targetName",
      "location": "http://your-target.com/",
      "attributes": {
        "WP_STEALTHY": "[true | false]",
        "WPVULNDB_API_TOKEN": "[wpvulndb.com api token]",
        "WP_ENUMERATE": "[Options]",
        "WP_MAX_DURATION": "[seconds]",
        "WP_THROTTLE": "[milliseconds]",
        "WP_REQUEST_TIMEOUT": "[seconds]",
        "WP_DETECTION_MODE": "[mixed | aggressive | passive]",
        "WP_USER_AGENT": "[userAgent]",
        "WP_HEADERS": "[headers]"
      }
    }
  }
]
```

Options for enumerate attribute:

```txt
Enumeration Process
Available Choices:
  vp  |  Vulnerable plugins
  ap  |  All plugins
  p   |  Plugins
  vt  |  Vulnerable themes
  at  |  All themes
  t   |  Themes
  tt  |  Timthumbs
  cb  |  Config backups
  dbe |  Db exports
  u   |  User IDs range. e.g: u1-5
         Range separator to use: '-'
         Value if no argument supplied: 1-10
  m   |  Media IDs range. e.g m1-15
         Note: Permalink setting must be set to "Plain" for those to be detected
         Range separator to use: '-'
         Value if no argument supplied: 1-100

Separator to use between the values: ','
Default: All Plugins, Config Backups
Value if no argument supplied: vp,vt,tt,cb,dbe,u,m
Incompatible choices (only one of each group/s can be used):
  - vp, ap, p
  - vt, at, t
```

## Example

Example configuration: (Note that the token isn't actually real 😉)

```json
[
  {
    "name": "wpscan",
    "context": "Example WPScan",
    "target": {
      "name": "Local Wordpress",
      "location": "http://wordpress.example.com",
      "attributes": {
        "WPVULNDB_API_TOKEN": "RVR4GztDG4sZdfYUVsvyX7fGHvFZMXa7plbsoRHssvq"
      }
    }
  }
]
```

Example Output:

```json
{
  "findings": [
    {
      "id": "e132b47a-9f2c-41cd-be9b-95dc948a8bd3",
      "name": "CMS Wordpress",
      "description": "CMS Wordpress Information",
      "category": "CMS Wordpress",
      "osi_layer": "APPLICATION",
      "severity": "INFORMATIONAL",
      "reference": {},
      "attributes": {
        "requests_done": "23",
        "db_update_finished": "",
        "version": "4.0.29",
        "start_time": "2020-01-16 15:05:08 +0000",
        "end_time": "2020-01-16 15:05:14 +0000"
      },
      "location": "http://wordpress.example.com",
      "false_positive": false
    }
  ]
}
```

## Development

### Configuration Options

To configure this service specify the following environment variables:

| Environment Variable         | Value Example |
| ---------------------------- | ------------- |
| `ENGINE_ADDRESS`             | http://engine |
| `ENGINE_BASIC_AUTH_USER`     | username      |
| `ENGINE_BASIC_AUTH_PASSWORD` | 123456        |

### Local setup

1. Clone the repository
2. You might need to install some dependencies `gem install sinatra rest-client`
3. Run locally `ruby src/main.rb`

### Test

To run the testsuite run:

`rake test`

### Build with docker

To build the docker container run:

`docker build -t IMAGE_NAME:LABEL .`

[![Build Status](https://travis-ci.com/secureCodeBox/scanner-cms-wpscan.svg?branch=master)](https://travis-ci.com/secureCodeBox/scanner-cms-wpscan)
[![License](https://img.shields.io/badge/License-Apache%202.0-blue.svg)](https://opensource.org/licenses/Apache-2.0)
[![GitHub release](https://img.shields.io/github/release/secureCodeBox/scanner-cms-wpscan.svg)](https://github.com/secureCodeBox/scanner-cms-wpscan/releases/latest)

[wpscan.io]: https://wpscan.io/
[wpscan.org]: https://wpscan.org/
