#!/usr/bin/env python
from collections import OrderedDict
import sys, json, yaml
import yaml.constructor

from yaml.representer import SafeRepresenter
from yaml import Dumper

key_order = ('id', 'id-platform', 
        'name', 
        'sources', 'type', 'path', 'branch', 'sha256', 'commands', 'dest-filename'
        'branch', 'build-runtime', 
        'build-options', 'build-args', 
        'runtime', 'runtime-version',
        'sdk', 'sdk-extensions',
        'inherit-extensions', 'platform-extensions',
        'modules'
        )
key_order = OrderedDict((k, i) for i, k in enumerate(key_order))

class Loader(yaml.Loader):
    def __init__(self, *args, **kwargs):
        yaml.Loader.__init__(self, *args, **kwargs)
        self.add_constructor(
            'tag:yaml.org,2002:map', type(self).construct_yaml_map)
        self.add_constructor(
            'tag:yaml.org,2002:omap', type(self).construct_yaml_map)


    def construct_yaml_map(self, node):
        data = OrderedDict()
        yield data
        value = self.construct_mapping(node)
        data.update(value)

    def construct_mapping(self, node, deep=False):
        if isinstance(node, yaml.MappingNode):
            self.flatten_mapping(node)
        else:
            raise yaml.constructor.ConstructError(None, None,
                'expected a mapping node, but found %s' % node.id,
                node.start_mark)

        mapping = OrderedDict()
        for key_node, value_node in node.value:
            key = self.construct_object(key_node, deep=deep)
            try:
                hash(key)
            except TypeError as err:
                raise yaml.constructor.ConstructError(
                    'while constructing a mapping', node.start_mark,
                    'found unacceptable key (%s)' % err, key_node.start_mark)
            value = self.construct_object(value_node, deep=deep)
            mapping[key] = value
        return OrderedDict(sorted(mapping.iteritems(), key=lambda k: key_order.get(k[0], float("inf"))))

def dict_representer(dumper, data):
    return dumper.represent_dict(data.iteritems())

Dumper.add_representer(OrderedDict, dict_representer)
Dumper.add_representer(str, SafeRepresenter.represent_str)
Dumper.add_representer(unicode, SafeRepresenter.represent_unicode)


if __name__ == '__main__':
    with open(sys.argv[1]) as f:
        yaml_dict = yaml.load(f, Loader=Loader)
        if len(sys.argv) == 3:
            print("Save new yaml to %s" % sys.argv[2])
            with open(sys.argv[2], 'w') as f:
                yaml.dump(yaml_dict, f, default_flow_style=False)
        else:
            print(json.dumps(yaml_dict, indent=4))
