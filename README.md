# Half-Life Dedicated Server v1.0.1.6 (WON2/Protocol 40) Image for Docker/Podman

[![](https://c5.patreon.com/external/logo/become_a_patron_button.png)](https://patreon.baseq.fr)
[![ko-fi](https://ko-fi.com/img/githubbutton_sm.svg)](https://ko-fi.com/P5P27UZHV)

This project creates a Docker image that automates setting up a Half-Life dedicated server, version 1.0.1.6 (also known as **Protocol 40**), using the WON2 protocol. This image also includes popular Counter-Strike beta mods compatible with this build of Half-Life that are still played by the community, which are Counter-Strike Beta 3.1, Beta 4.0, Beta 5.2, and Beta 6.1.

#### Related projects
- [Docker/Podman image for HLDS 1.1.1.0](https://github.com/Ch0wW/docker-hlds-won2)

--------------------

# Requirements
- Basic Linux skills,
- Either `docker` (easier to set up) **__OR__** `podman` version 5.4.2 or above (advanced but more secure).

> [!TIP]
> - We will have to create a new user for safety reasons ; **I recommend naming the freshly created user `hluser`, as that is the one I will use throughout the installation guide** ! 
> - Also, we assume you are using Debian 13 as your Linux OS. If not, please adapt some commands to your needs. 

### Why making this project ?

There are a few communities around the World that still enjoy playing the early betas of Counter-Strike, either for rediscovering how it was back in the day, or simply out of pure nostalgia. However, I have noticed that community-wise, there wasn't really any project available that allows you to create servers for HL 1.0.1.6 in a matter of minutes. Since game preservation is important, I decided to provide a ready-to-use image for that purpose.  

> [!WARNING]
> Considering how some early Counter-Strike betas only were distributed for Windows, some versions aren't available yet... Rest assured, a Wine-emulated container for the missing builds is in the works 😉

### Features
* Creates a barebones HLDS Environment using Debian (i386), using vanilla files and security patches only when applicable.
* Only takes ~500MB of Disk Space !
* Includes all the dedicated server files in its vanilla configuration that can be mostly reconfigured without recompiling the image.
* Advertises servers on both WON2.NET and the Order of Phalanx's masterservers.

### Included mods
- Counter-Strike Beta 6.1
- Counter-Strike Beta 5.2
- Counter-Strike Beta 4.0
- Counter-Strike Beta 3.1

# Installation instructions

## Docker Installation 

0) If not already done, install Docker.

1) First of all, make sure you have created the `hluser` user on your server. Don't forget to add the user to the `docker` group (`usermod -aG docker hluser`)

2) Log in as `hluser`.

3) Clone the project, and enter the project's directory.

4) Build the image required for the server (will take ~5 minutes)
```sh
docker build -t hlds1016:latest .
```

5) Then, copy the `docker-compose.yml` file to `docker-compose.override.yml`
```bash
cp docker-compose.yml docker-compose.override.yml
```

6) Edit `docker-compose.override.yml` to your likings.

> [!CAUTION]
> You need to set the UID/GID of the user you have created (using the command `id`), and replace it in the `user:"1000:1000"` part ; **otherwise you will have permission issues**.

>[!NOTE]
> The commandline that is used to start the server is located in the `command` part. 

If you need to change the port of your server, change the `-port 27015` parameter (in the `command` section) with the desired port of your choice.

For instance, here is a `docker-compose.override.yml` file which will create a CS Beta 6.1 server on cs_assault on port 27010 with 32 players slots: 

```yml
services:
  hlds-server:
    image: "hlds1016"
    network_mode: host
    user: "1000:1000" # <- IMPORTANT !! Change this to your UID:GID to fix potential permission issues !
    volumes:
      - ./config/cstrk61:/server/cstrk61
    command:
      - -port 27010 -game cstrk61 +map cs_assault +maxplayers 32
```

7) Once done, just execute `docker compose up` to start up the server. If everything works well, you should be able to connect to the server.

In case you need to rebuild the image (for advanced purposes only), just type `docker compose build` and you should be good to go.


## Podman installation

0) If not already done, install Podman. If you also have package `acl`, it's a good time to install it as well.
```sh
sudo apt install podman acl
```

1) First of all, make sure you have created the `hluser` user on your server. Don't forget to add subuid/subgid support (`usermod --add-subuids 100000-165535 --add-subgids 100000-165535 hluser`)

2) As `root`, we will enable lingering for our user (so that the server will still be active when not connected through SSH): 
```bash
loginctl enable-linger hluser
```

3) In a new SSH connection, connect as `hluser`.

4) Clone the project, and enter the project's directory.

5) We'll set proper permissions for later, so that our user `hluser` will still have access to files later on on the `config` subdirectories. This will fix new files permissions for both the container & our user, as well as allowing custom sprays to be saved.
```sh
setfacl -R -d -m u:hluser:rwx ~/docker-hlds-won2-1016/config/*
setfacl -R -m u:hluser:rwx ~/docker-hlds-won2-1016/config/*
```

6) Build the image required for the server (will take ~5 minutes)
```sh
podman build -t hlds1016:latest .
```

7) We will create the subfolders required for a rootless podman configuration, and copy the container inside it.

```bash
mkdir -p ~/.config/containers/systemd
cp hlds1016.container ~/.config/containers/systemd/
```

8) Edit `~/.config/containers/systemd/hlds1016.container` to your likings.

>[!NOTE]
> The commandline that is used to start the server is located in the `Exec` part. 

If you need to change the port of your server, change the `-port 27015` parameter (in the `command` section) with the desired port of your choice.

For instance, here is a container file (= *quadlet*) which will create a CS Beta 6.1 server on cs_assault on port 27010 with 32 players slots: 

```systemd
[Unit]
Description=HLDS 1.0.1.6 (WON2) Server
Wants=network-online.target
After=network-online.target

[Container]
Image=localhost/hlds1016
Network=host
PodmanArgs=-it
UserNS=keep-id

# Volumes
Volume=%h/docker-hlds-won2-1016/config/cstrk61:/server/cstrk61:z

# Command user
Exec=-port 27010 -game cstrk61 +map cs_assault +maxplayers 32

[Service]
Restart=on-failure
TimeoutSec=10

[Install]
WantedBy=multi-user.target
```

9) Refresh the systemd services & containers, then start the server.
```bash
systemctl --user daemon-reload
systemctl --user start hlds1016
```

> [!NOTE]
> - You will have to make one container file per server. 
> - If the service is not properly detected by podman/systemd, you can have a basic idea of what's wrong with this command : `/usr/libexec/podman/quadlet -dryrun -user`

> [!WARNING]
> Due to how systemd works, if you changed anything within the quadlet, or created a new quadlet, you will have to type `systemctl --user daemon-reload` in order to refresh the files. 

## Customizing your server configuration
Simply go to the `config` folder, and modify the required folders you wish.

- `config/cstrk61` is for Counter-Strike Beta 6.1.
- `config/cstrk52` is for Counter-Strike Beta 5.2.
- `config/cstrk40` is for Counter-Strike Beta 4.0.
- `config/cstrk31` is for Counter-Strike Beta 3.1.
- `config/valve` is for Half-Life. 

> [!NOTE]
> Since no playerbase exists for Half-Life WON2 (people play it on STEAM instead), none of the system files have been included. 
> If you still want to include custom data or config for a Half-Life 1 server, simply add whatever you wish inside the folder, and rebuild the image.

# Frequently Asked Questions

### Do I have to include +sv_lan 1?
❌ **No need to** ! It's already included inside `hlds_start` (which is basically a renamed `hlds_run` script), so you don't have to!

### Will this work natively with that Half-Life 1.0.1.6 package I found online?
✅ **Of course**! This project will register your dedicated server to both the WON2.NET and the Order of Phalanx masterservers!

### Why is there no presence of CS Beta 1.x, 2.x?
**Simply because these versions do not have Linux builds available**! You can verify them all on this [GitHub repository](https://github.com/Ch0wW/counterstrike-betas) if you need more information.

### How can I access RCON if the port is not the default one (i.e. 27015) ? Either it rejects it, or it says bad password despite being correct.
By default, Half-Life 1.0.1.6 clients **assume** that the rcon port used for remote access is 27015. You will have to use `rcon_port "27016"` (adapt 27016 to your server port) to make it work.

> [!WARNING]
> A WINE image is in the works for hosting these missing builds on Linux !

-----------

This project uses files copyrighted by VALVe. 

[![](https://c5.patreon.com/external/logo/become_a_patron_button.png)](https://patreon.baseq.fr)
[![ko-fi](https://ko-fi.com/img/githubbutton_sm.svg)](https://ko-fi.com/P5P27UZHV)