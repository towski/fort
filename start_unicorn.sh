#!/bin/sh
VERBOSE=true unicorn -c unicorn.rb -E production config.ru -D
