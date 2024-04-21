#!/bin/sh

flutter test --coverage
# 下記でcoverage計測対象から外せる.
# lcov --remove coverage/lcov.info 'lib/presentation/widgets/*' 'lib/repository/*' -o coverage/lcov.info
genhtml coverage/lcov.info -o coverage/html
