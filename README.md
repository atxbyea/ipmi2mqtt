# ipmi2mqtt


Simple IPMI to MQTT docker container to push trival data from IPMI to MQTT.

My usecase was to get a power reading from a Dell R510 (which did not publish realtime power usage via SNMP) to Home Assistant
Can be used for basically anything tbh


Getting data into HA via `sensors.yaml`

```
  - platform: mqtt
    state_topic: "idracpower"
    name: "idracpower Power"
    unit_of_measurement: "W"
```

Lets pull that into `statistics` (still in `sensors.yaml`)

```
  - platform: statistics
    name: "idracpower power per minute"
    entity_id: sensor.idracpower_power
    sampling_size: 60
```

And also convert it into kWH (still in `sensors.yaml`)

```
  - platform: template
    sensors:
      idracpower_realtime_power:
        friendly_name: "idracpower Realtime Power"
        value_template: "{{state_attr('sensor.idracpower_power_per_minute', 'total') / (1000 * 60) }}"
        unit_of_measurement: 'kwH'
```

And get a monthly utility meter of it from `configuration.yaml`

```
utility_meter:
  idracpower_manedlig:
    source: sensor.idracpower_realtime_power
    cycle: monthly
```

Thanks to Villhellm and Tediore for inspiration 

https://github.com/Villhellm
https://github.com/Tediore
