---
title: "WPScan"
path: "scanner/WPScan"
category: "scanner"
usecase: "Wordpress Vulnerability Scanner"
release: "https://img.shields.io/github/release/secureCodeBox/scanner-cms-wpscan.svg"

---

![WPScan Logo](https://raw.githubusercontent.com/wpscanteam/wpscan/gh-pages/images/wpscan_logo.png)

WPScan is a free, for non-commercial use, black box WordPress vulnerability scanner written for security professionals and blog maintainers to test the security of their sites.

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
Since we currently do not provide a Wordpress test-site we have no example to offer.

## Development

### Configuration Options

To configure this service specify the following environment variables:

| Environment Variable       | Value Example |
| -------------------------- | ------------- |
| ENGINE_ADDRESS             | http://engine |
| ENGINE_BASIC_AUTH_USER     | username      |
| ENGINE_BASIC_AUTH_PASSWORD | 123456        |

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
