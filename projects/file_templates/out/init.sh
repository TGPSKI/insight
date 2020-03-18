#!/bin/sh -ex

[ "$UID" -eq 0 ] || exec sudo "$0" "$@"

APP_NAME=foo
REGION=us-west-2
ENVIRONMENT=fantasyland
