#!/usr/bin/env python

import time

def generate_zoneserial():
  grains = {}
  grains['zoneserial'] = int(time.time() / 10)
  return grains
