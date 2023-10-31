#!/bin/sh
echo "Cleaning Up ..."
rm -rf  ${JMETER_HOME}/LICENSE \
        ${JMETER_HOME}/NOTICE \
        ${JMETER_HOME}/README.md \
        ${JMETER_HOME}/licenses \
        ${JMETER_HOME}/printable_docs \
        ${JMETER_HOME}/docs \
        /var/lib/{apt,dpkg,cache,log}/*
echo "Cleaning Done."