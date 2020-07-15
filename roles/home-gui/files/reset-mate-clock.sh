#!/bin/sh
dconf load /org/mate/panel/objects/clock/prefs/ << __EOF__
[/]
show-temperature=false
expand-locations=true
format='24-hour'
show-weather=false
cities=[                                               \
        '<location name="Sydney"                       \
                   timezone="Australia/Sydney"         \
                   code="YSSY"                         \
                   latitude="-33.950001"               \
                   longitude="151.183334"              \
                   />',                                \
        '<location name="Paris"                        \
                   timezone="Europe/Paris"             \
                   code="LFPG"                         \
                   latitude="49.016666"                \
                   longitude="2.533333"                \
                   />',                                \
        '<location name="London"                       \
                   timezone="Europe/London"            \
                   code="EGLC"                         \
                   latitude="51.500000"                \
                   longitude="-0.500000"               \
                   />',                                \
        '<location name="–Zulu–"                       \
                   timezone="UTC"                      \
                   />',                                \
        '<location name="New York"                     \
                   timezone="America/New_York"         \
                   code="KNYC"                         \
                   latitude="40.783333"                \
                   longitude="-73.966667"              \
                   />',                                \
        '<location name="Seattle"                      \
                   timezone="America/Los_Angeles"      \
                   code="KSEA"                         \
                   latitude="47.545834"                \
                   longitude="-122.313614"             \
                   />'                                 \
]
__EOF__
