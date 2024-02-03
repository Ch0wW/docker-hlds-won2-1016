# docker-hlds-won2-1016

[![ko-fi](https://ko-fi.com/img/githubbutton_sm.svg)](https://ko-fi.com/P5P27UZHV)

This project generates a Docker image that automates setting up a Half-Life dedicated server, version 1.0.1.6, using the WON2 protocol. This docker image also includes several popular mods that are still played using this version which are Counter-Strike Beta 4.0, Beta 5.2, and Beta 6.1.

#### Related projects
- [Docker image for HLDS 1.1.1.0](https://github.com/Ch0wW/docker-hlds-won2)
- [Docker image for HLDS 1.1.0.4](https://github.com/Ch0wW/docker-hlds-won2-1104)

--------------------

# Requirements
- docker
- docker-compose

### Why this docker ?

There are a few communities around the World that still play older Counter-Strike 1.5 builds online. However, I have noticed that some Linux distributions are not friendly with this version of HLDS due to potential library incompatibilities, and may instantly crash upon starting.

A workaround was found since then, but I still wanted to provide a ready to use image for preservation purposes. Since Docker allows creating "*sandboxed*" environments using other versions of Linux, I created this project.

### Features
* Creates a barebones HLDS Environment using Debian 12 (i386), using vanilla files and security patches only.
* Server settings can be configured without the requirement of rebuilding the docker image (with the exception of Half-Life 1)

### Included mods
- Counter-Strike beta 6.1
- Counter-Strike beta 5.2
- Counter-Strike beta 4.0

### Installation/Usage

Simply edit the `docker-compose.yml` to add or modify anything you require.

If you need to change the port of your server, change all occurences of `27015` (= in `ports` and in the `command` sections) to the desired port of your choice.

Change also the `user` token so that it is checking with the user and group running the container, to avoid upload issues or potential permission problems.

**Example of Docker file**
```yml
version: "3.0"

services:
  hlds:
    build:
      context: .
      dockerfile: Dockerfile
    user: "1000:1000" # <- Change this to your UID:GID
    volumes:
      - ./config/cstrk52:/server/hlds_l/cstrk52 
      - ./config/cstrk61:/server/hlds_l/cstrk61
      - ./config/cstrk40:/server/hlds_l/cstrk40 
      - ./config/cstrk31:/server/hlds_l/cstrk31
    ports:
      - 27015:27015
      - 27015:27015/udp
    command:
      - -port 27015 -game cstrk61 +map de_dust +maxplayers 16
    security_opt:
      - no-new-privileges:true
```

Once done, just execute `docker-compose up` to make sure everything works as intended, and you should be good to go.

If you need to rebuild the image (for instance for testing or to add a few additional things), just type `docker-compose build` and you should be good to go.

### Customisation
Simply go to the `config` folder, and modify the required folders you wish.

- `config/cstrk61` is for Counter-Strike Beta 6.1.
- `config/cstrk52` is for Counter-Strike Beta 5.2.
- `config/cstrk40` is for Counter-Strike Beta 4.0.
- `config/cstrk31` is for Counter-Strike Beta 3.1.
- `config/valve` is for Half-Life. **However, since no playerbase really exists for Half-Life WON2 (people play it on STEAM instead), this only includes the WON2 masterservers.** 

### Do I have to include +sv_lan 1?
Nope! It's already included inside `hlds_start` (which is basically a renamed `hlds_run` script), so you don't have to!

-----------

This project uses files copyrighted by VALVe. 