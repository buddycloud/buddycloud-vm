#!/usr/bin/env python

from __future__ import absolute_import
import salt.modules.cmdmod

__salt__ = {
  'cmd.run': salt.modules.cmdmod._run_quiet,
  'cmd.retcode': salt.modules.cmdmod._retcode_quiet,
  'cmd.run_all': salt.modules.cmdmod._run_all_quiet
}

def extract_nameservers():
  grains = {}
  nameservers = __salt__['cmd.run'](
    'grep -hr ^nameserver /run/resolvconf/interface/|sed "s:^nameserver ::"').splitlines()
  grains['nameservers'] = nameservers
  return grains
