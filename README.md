# docker-hlds-won2
A docker image that automates setting up a 1.0.1.6 Half-Life dedicated server, using the WON2 protocol, required to play various betas and releases of Counter-Strike.

### Other projects related to WON2 HLDS...
- If you want to host a server for **Counter-Strike 1.5** and various pre-Steam mods, you should [check this repository instead](https://github.com/Ch0wW/docker-hlds-won2).
- If you want to host a server with CS1.0 or Beta 7.1, and various mods that'd work with HL 1.1.0.4, [check this repository](https://github.com/Ch0wW/docker-hlds-won2-1104).

# Requirements
- Docker
- docker-compose

### Features
* Creates a barebones HLDS Environment using Debian 12 (i386), using vanilla files and security patches only.
* Server settings can be configured without the requirement of rebuilding the docker image (with the exception of Half-Life 1)

### Included mods
- Counter-Strike beta 6.1
- Counter-Strike beta 5.2
- Counter-Strike beta 4.0

### Installation/Usage

Simply edit the `docker-compose.yml` to add or modify anything you require.

If you need to change the port of your server, change all occurences (= in `ports` and in the `command` sections)

**Example of Docker file**
```
version: "3.0"

services:
  hlds:
    build:
      context: .
      dockerfile: Dockerfile
    volumes:
      - ./config/cstrk52:/server/hlds_l/cstrk52 
      - ./config/cstrk61:/server/hlds_l/cstrk61
      - ./config/cstrk40:/server/hlds_l/cstrk40 

    ports:
      - 27015:27015
      - 27015:27015/udp
    command:
      - ./hlds_run -port 27015 -game cstrk61 +map de_dust +maxplayers 16

```

once done, just execute `docker-compose up` to make sure everything works as intended, and you should be good to go.

### Customisation

Simply go to the `config` folder, and modify the required folders you wish.

- `config/cstrk40` is for Counter-Strike Beta 4.0.
- `config/cstrk52` is for Counter-Strike Beta 5.2.
- `config/cstrk61` is for Counter-Strike Beta 6.1.
-----------

This project uses files copyrighted by VALVe. 