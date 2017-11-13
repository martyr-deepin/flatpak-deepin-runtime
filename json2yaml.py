#!/usr/bin/env python

import sys, json, yaml
with open(sys.argv[1]) as f:
    if sys.argv[1].endswith('yaml'):
        print(json.dumps(yaml.load(f), indent=4))
    else:
        print(yaml.safe_dump(json.load(f), default_flow_style=False))
