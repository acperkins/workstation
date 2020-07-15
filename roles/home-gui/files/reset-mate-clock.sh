#!/bin/sh
dconf load /org/mate/panel/objects/clock/prefs/ << __EOF__
[/]
show-temperature=false
expand-locations=true
format='24-hour'
cities=['<location name="UTC" city="" timezone="GMT" latitude="-0.000000" longitude="-0.000000" code="-" current="false"/>', '<location name="New York" city="" timezone="America/New_York" latitude="-0.000000" longitude="-0.000000" code="-" current="false"/>', '<location name="Los Angeles" city="" timezone="America/Los_Angeles" latitude="-0.000000" longitude="-0.000000" code="-" current="false"/>', '<location name="London" city="" timezone="Europe/London" latitude="-0.000000" longitude="-0.000000" code="-" current="false"/>']
custom-format=''
show-weather=false
__EOF__
