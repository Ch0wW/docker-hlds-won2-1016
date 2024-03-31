# docker-hlds-won2-1016

[![](https://c5.patreon.com/external/logo/become_a_patron_button.png)](https://patreon.baseq.fr)
[![ko-fi](https://ko-fi.com/img/githubbutton_sm.svg)](https://ko-fi.com/P5P27UZHV)

This project creates a Docker image that automates setting up a Half-Life dedicated server, version 1.0.1.6, using the WON2 protocol. This docker image also includes several popular Counter-Strike beta mods that are still played by the community, which are Counter-Strike Beta 3.1, Beta 4.0, Beta 5.2, and Beta 6.1.

**Please note this project is done independently of CS-Legacy or any other known retro-CS communities.**

#### Related projects
- [Docker image for HLDS 1.1.1.0](https://github.com/Ch0wW/docker-hlds-won2)

--------------------

# Requirements
- docker
- docker-compose

### Why this docker ?

There are a few communities around the World that still play the betas of Counter-Strike online. However, I have noticed that community-wise, noone took time to create an easy way to create servers in a matter of seconds. As a result, creating a server is messy and unreliable, which is not really a good way to bring new players. 

This project makes sure everyone can host these versions of Counter-Strike in a very simple and configurable way.

### Features
* Creates a barebones HLDS Environment using Debian (i386), using vanilla files and security patches only when applicable.
* Server settings can be configured without the requirement of rebuilding the docker image (with the exception of Half-Life 1)
* Everything is 100% vanilla, with the only exception of the custom masterservers that the community are using.

### Included mods
- Counter-Strike beta 6.1
- Counter-Strike beta 5.2
- Counter-Strike beta 4.0
- Counter-Strike beta 3.1

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

If you need to rebuild the image (to add a few additional things for instance), just type `docker-compose build` and you should be good to go.

### Customisation
Simply go to the `config` folder, and modify the required folders you wish.

- `config/cstrk61` is for Counter-Strike Beta 6.1.
- `config/cstrk52` is for Counter-Strike Beta 5.2.
- `config/cstrk40` is for Counter-Strike Beta 4.0.
- `config/cstrk31` is for Counter-Strike Beta 3.1.
- `config/valve` is for Half-Life. **However, since no playerbase really exists for Half-Life WON2 (people play it on STEAM instead), this only includes the WON2 masterservers.** 

# FAQ

### Do I have to include +sv_lan 1?
Nope! It's already included inside `hlds_start` (which is basically a renamed `hlds_run` script), so you don't have to!

### Will this work natively with that Half-Life 1.0.1.6 package I found online?
Of course! The server will be spread to both the WON2 and the Order of Phalanx masterservers!

### Why is there no presence of CS Beta 1.x, 2.x?
Because these versions have no known existance of Linux builds, that this project is based on! You can verify them all on this [GitHub repository](https://github.com/Ch0wW/counterstrike-betas) if you need more information.

-----------

This project uses files copyrighted by VALVe. 