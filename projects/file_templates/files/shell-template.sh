#!/bin/sh -ex

[ "$UID" -eq 0 ] || exec sudo "$0" "$@"

APP_NAME=${app_name}
REGION=${aws_region}
ENVIRONMENT=${environment}
