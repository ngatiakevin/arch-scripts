#!/bin/bash

set -e

echo "Updating resolvconf..."
sudo /usr/bin/resolvconf -u


echo "Bringing up WireGuard (wg0)..."
sudo /usr/bin/wg-quick up wg0


echo "WireGuard is up."
