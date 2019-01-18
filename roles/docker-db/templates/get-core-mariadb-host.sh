#!/bin/bash
./rancher ps -c --format '{{.Container.PrimaryIpAddress}} : {{.Container.Name}}' | grep core-mariadb | awk '{print $1}'
