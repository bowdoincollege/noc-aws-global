#!/usr/bin/env python
import json
import subprocess


def splitzone(zone):
    labels = zone.split(".")
    return (labels[0], ".".join(labels[1:]))


def delegations():
    command = "terraform output -json dns_delegations"
    try:
        return json.loads(subprocess.check_output(command.split()))
    except subprocess.CalledProcessError as err:
        print(err)
        exit


def print_bind_delegations():
    for delegation in delegations():
        current, parent = splitzone(delegation["zone"])
        print(f"; Add to {parent} zone file\n")
        print("; aws authoritative zone delegations")
        for ns in delegation["name_servers"]:
            name = ".".join([ns["name"], current])
            print(f"{name:<24}IN      A               {ns['ipv4_addr']}")
            print(f"{  '':<24}IN      AAAA            {ns['ipv6_addr']}")
        for n, ns in enumerate(delegation["name_servers"]):
            name = ".".join([ns["name"], current])
            print(f"{current if n==0 else '':<24}IN      NS              {name}")


if __name__ == "__main__":
    print_bind_delegations()
