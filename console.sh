#!/usr/bin/env bash

cd "$( dirname "${BASH_SOURCE[0]}" )"

docker-compose exec mongo-router-01 bash
