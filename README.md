---
title: "WPscan"
path: "scanner/WPscan"
category: "scanner"
usecase: "Content Management System"

---

WPScan is a free, for non-commercial use, black box WordPress vulnerability scanner written for security professionals and blog maintainers to test the security of their sites.

<!-- end -->

# About

This repository contains a self contained µService utilizing the WPScan scanner for the secureCodeBox project.

Further Documentation:

- [Project Description][scb-project]
- [Developer Guide][scb-developer-guide]
- [User Guide][scb-user-guide]

## Configuration Options

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

## WpScan Parameters

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
        "WP_STEALTHY": "true",
        "WP_ENUMERATE": "[Options]",
        "WP_MAX_DURATION": "[Seconds]",
        "WP_THROTTLE": "[Milliseconds]",
        "WP_REQUEST_TIMEOUT": "[Seconds]",
        "WP_DETECTION_MODE": "[Options]",
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

## Build with docker

To build the docker container run:

`docker build -t IMAGE_NAME:LABEL .`

[![Build Status](https://travis-ci.com/secureCodeBox/scanner-cms-wpscan.svg?branch=develop)](https://travis-ci.com/secureCodeBox/scanner-cms-wpscan)
[![License](https://img.shields.io/badge/License-Apache%202.0-blue.svg)](https://opensource.org/licenses/Apache-2.0)
[![GitHub release](https://img.shields.io/github/release/secureCodeBox/scanner-cms-wpscan.svg)](https://github.com/secureCodeBox/scanner-cms-wpscan/releases/latest)

[scb-project]: https://github.com/secureCodeBox/secureCodeBox
[scb-developer-guide]: https://github.com/secureCodeBox/secureCodeBox/blob/develop/docs/developer-guide/README.md
[scb-developer-guidelines]: https://github.com/secureCodeBox/secureCodeBox/blob/develop/docs/developer-guide/README.md#guidelines
[scb-user-guide]: https://github.com/secureCodeBox/secureCodeBox/tree/develop/docs/user-guide
