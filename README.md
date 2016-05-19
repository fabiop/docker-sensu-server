# docker-sensu-server

Debian jessie and sensu stuff.

It runs redis, rabbitmq-server, uchiwa, sensu-api, sensu-server processes and postfix.

**Important note**


This is a modified version to:

- Handle mailing locally (inside container) through Postfix
- Allow usage of internal or external parts/services through declaration of docker env variables


This approach is far from ideal because redis, rabbit, sensu-server, uchiwa and postfix
are all running in the same container which is not exactly how microservices should be
implemented ... :)


It's meant to be used for:
- Small tasks, to reduce clustering and ha complexity
- As a stepping stone to split up this in separate containers
- As an exercise or test to understand how to set up and use Sensu


Thanks to [Original project hiroakis/docker-sensu-server](https://github.com/hiroakis/docker-sensu-server).
and to fork to debian -> https://github.com/AlbanMontaigu/docker-sensu-server



## Installation

Install from docker index:

```
docker pull fabiop/sensu-server-mailer
```

## Run

```
docker run -d -p 3000:3000 -p 4567:4567 -p 5671:5671 -p 15672:15672 -e ALERT_EMAIL=foo@bar.com -e REDIS_SERVER=redis.foo.com -e REDIS_PORT=1111 -e RABBIT_SERVER=rabbit.foo.com -e RABBIT_PORT=2222 -e RABBIT_VHOST=/Sensu -e RABBIT_USER=sensu -e RABBIT_PASS=pass fabiop/sensu-server-mailer
```


## Run with docker-compose
```
sensu-server-mailer:
  image: fabiop/sensu-server-mailer
  restart: unless-stopped
  container_name: sensu-server-mailer
  ports:
    - "5671:5671"
    - "5672:5672"
    - "15672:15672"
    - "3000:3000"
    - "4567:4567"
  environment:
    - ALERT_EMAIL=my-email@foo.com
    - REDIS_SERVER=redis.foo.com 
    - REDIS_PORT=1111 
    - RABBIT_SERVER=rabbit.foo.com 
    - RABBIT_PORT=5671 
    - RABBIT_VHOST=/Sensu 
    - RABBIT_USER=sensu 
    - RABBIT_PASS=pass 
```


## How to access via browser and sensu-client


### rabbitmq console

* http://your-server:15672/
* id/pwd : sensu/password


### uchiwa

* http://your-server:3000/


### sensu-client

To run sensu-client, create client.json (see example below), then just run sensu-client process.

These are examples of sensu-client configuration.

* /etc/sensu/config.json

```
{
  "rabbitmq": {
    "host": "sensu-server-ipaddr",
    "port": 5671,
    "vhost": "/sensu",
    "user": "sensu",
    "password": "password",
    "ssl": {
      "cert_chain_file": "/etc/sensu/ssl/cert.pem",
      "private_key_file": "/etc/sensu/ssl/key.pem"
    }
  }
}
```

* /etc/sensu/conf.d/client.json

```
{
  "client": {
    "name": "sensu-client-node-hostname",
    "address": "sensu-client-node-ipaddr",
    "subscriptions": [
      "common",
      "web"
    ]
  },
  "keepalive": {
    "thresholds": {
      "critical": 60
    },
    "refresh": 300
  }
}
```

## Documentation and references

* [Docker hub container https://hub.docker.com/r/fabiop/sensu-server-mailer/](https://hub.docker.com/r/fabiop/sensu-server-mailer/)
* [Original project hiroakis/docker-sensu-server](https://github.com/hiroakis/docker-sensu-server)
* [Port to Debian Jessie AlbanMontaigu/docker-sensu-server](https://github.com/AlbanMontaigu/docker-sensu-server)
* [Sensu – Adding Check’s and Handler’s](https://beingasysadmin.wordpress.com/2013/04/26/378/)
* [GitHub sensu-plugins-mailer](https://github.com/sensu-plugins/sensu-plugins-mailer)
* [Adding a Sensu handler](https://sensuapp.org/docs/0.16/adding_a_handler)
* [Comparing Seven Monitoring Options for Docker](http://rancher.com/comparing-monitoring-options-for-docker-deployments/)

## License

MIT
