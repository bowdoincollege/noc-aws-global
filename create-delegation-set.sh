#!/bin/bash

set -euxo pipefail

aws route53 create-reusable-delegation-set --caller-reference "Bowdoin"
