# Star Reminder

Last week, I met this scenario again:

> I was reading email subscriptions and surfing online. Somehow I was linked to an awesome Github repo. I was going to give it a star, but to surprisingly find out it's already been starred.

It happens sometimes. Therefore, I'm wondering why not to create another email subscription, which gives me a digest of my starred projects every day, helps refresh my memory and dig into one or two projects every once a while.

I'd love to define the MVP as:

+ A service to email me a digest of 3 starred Github projects at 9am every day. #v0.1

To make it further, it could be:

+ A service to email user a digest of {2,3,5} starred Github projects at {9am, 4pm} every {day, week}. #v1

To generalize:

+ a service to notify (email, slack..) user a digest of an amount (2, 3...) of starred items (Github projects, Stack Overflow answers...) at a designated time (9am, 4pm...) every once a while (everyday, every week...). #v8

## Vesion 0.1

+ Set up mailer template
+ Request Github API by Octokit
+ Create model by Ohm
+ Add tests
+ Build scripts for basic tasks
+ Add crontab jobs by whenever
+ Dockerize
+ Use Circle CI to run tests and build image

## Development

1. To fill in the `.env`

```sh
$ cp .env.sample .env
```

2. To start Redis:

```sh
$ redis-server
```

3. To play around:

```
$ bundle exec rake -T
```

## Deployment

+ [CircleCI](https://circleci.com/gh/ifyouseewendy/star-reminder/tree/master)
+ [Loggly](https://ifyouseewendy.loggly.com/search?terms=tag:ruby)
+ [Datadog](https://app.datadoghq.com/dash/336154/star-reminder?live=true&page=0&is_auto=false&from_ts=1502122701232&to_ts=1502126301232&tile_size=m)

1. After Git push the new changes, Circle CI will run the tests and build the image, which is at [hub.docker.com/r/ifyouseewendy/star-reminder/](https://hub.docker.com/r/ifyouseewendy/star-reminder/)

2. To fetch the update and build

```sh
$ docker-compose build --pull
```

3. To init up or restart the service

```sh
$ docker-compose up &
$ # docker-compose restart &
```

4. Manually add user email and github username

```sh
$ rake add_user USER=ifyouseewendy@gmail.com GITHUB_USER=ifyouseewendy
```

5. Send email every day

Note:

Right now, I'm deploying it onto a barebone server on Linode. I have to login to the server to pull the updates and restart the service. It's not a perfect working flow as I'd expect.
Ideally, I'd love to <1. make my local dev machine as a manager docker machine <2. add the server as a worker docker machine and join the same swarm <3. provision the updates from manager to worker. I assume if I use Digital Ocean or AWS which provides the docker machien support driver, it should work.
Anyway, I'm still learning and will fix it someday.
