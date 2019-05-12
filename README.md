[![Build Status](https://travis-ci.com/jar349/wemoctl.svg?branch=master)](https://travis-ci.com/jar349/wemoctl)

# wemoctl
A command-line interface for controlling Belkin WeMo Smart Devices.

## Usage
#### As a cron job
If you want to control devices as a cron job, there's a [cron wrapper script](https://github.com/jar349/wemoctl/blob/master/bin/cron-wrapper.sh)
that you can use.  You don't even need to clone or download this repo - just the script. It assumes that you have 
[docker](https://docs.docker.com/install/) installed.  The value of this script is that it only writes to stdout if 
there's an error.  That way, you won't receive emails for successes.  In addition, it downloads the latest version of
the docker image before it runs each time.

To setup the cronjob, I will assume that you've downloaded the `bin/cron-wrapper.sh` script to `/usr/local/bin`.  Then,
run `crontab -e` to edit your crontab and add entries that look something like this:
```
0 * * * * /usr/local/bin/cron-wrapper.sh "White LED Bar 1" on
5 * * * * /usr/local/bin/cron-wrapper.sh "White LED Bar 1" off
```
The above lines will turn on the device named "White LED Bar 1" at the top of every hour and will turn it off five
minutes past every hour.

#### As a docker container
If you want to control devices on the command line, as a docker container is the best way because all the dependencies
of the `wemoctl` application are already setup for you.  There's no need to clone or download this repo because I've 
built the docker image and uploaded it to [GitHub](https://github.com/jar349/wemoctl/packages) for you.

First, download the docker image:
```
docker pull docker.pkg.github.com/jar349/wemoctl/wemoctl:latest
```
Then, if you want to turn on a device called "White LED Bar 1" do this:
```
docker run --rm --network host jar349/wemoctl:latest pipenv run wemoctl power --device "White LED Bar 1" on
```

#### As a python application
If you're familiar with python applications and want to run the `wemoctl` command without using a docker container, 
clone this repository, run [the bootstrap script](https://github.com/jar349/wemoctl/blob/master/script/bootstrap), and
then run:
```
pipenv run wemoctl power --device "White LED Bar 1" on
```
