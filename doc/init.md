Sample init scripts and service configuration for meowd
==========================================================

Sample scripts and configuration files for systemd, Upstart and OpenRC
can be found in the contrib/init folder.

    contrib/init/meowd.service:    systemd service unit configuration
    contrib/init/meowd.openrc:     OpenRC compatible SysV style init script
    contrib/init/meowd.openrcconf: OpenRC conf.d file
    contrib/init/meowd.conf:       Upstart service configuration file
    contrib/init/meowd.init:       CentOS compatible SysV style init script

Service User
---------------------------------

All three Linux startup configurations assume the existence of a "meow" user
and group.  They must be created before attempting to use these scripts.
The OS X configuration assumes meowd will be set up for the current user.

Configuration
---------------------------------

At a bare minimum, meowd requires that the rpcpassword setting be set
when running as a daemon.  If the configuration file does not exist or this
setting is not set, meowd will shutdown promptly after startup.

This password does not have to be remembered or typed as it is mostly used
as a fixed token that meowd and client programs read from the configuration
file, however it is recommended that a strong and secure password be used
as this password is security critical to securing the wallet should the
wallet be enabled.

If meowd is run with the "-server" flag (set by default), and no rpcpassword is set,
it will use a special cookie file for authentication. The cookie is generated with random
content when the daemon starts, and deleted when it exits. Read access to this file
controls who can access it through RPC.

By default the cookie is stored in the data directory, but it's location can be overridden
with the option '-rpccookiefile'.

This allows for running meowd without having to do any manual configuration.

`conf`, `pid`, and `wallet` accept relative paths which are interpreted as
relative to the data directory. `wallet` *only* supports relative paths.

For an example configuration file that describes the configuration settings,
see `contrib/debian/examples/meow.conf`.

Paths
---------------------------------

### Linux

All three configurations assume several paths that might need to be adjusted.

Binary:              `/usr/bin/meowd`  
Configuration file:  `/etc/meow/meow.conf`  
Data directory:      `/var/lib/meowd`  
PID file:            `/var/run/meowd/meowd.pid` (OpenRC and Upstart) or `/var/lib/meowd/meowd.pid` (systemd)  
Lock file:           `/var/lock/subsys/meowd` (CentOS)  

The configuration file, PID directory (if applicable) and data directory
should all be owned by the meow user and group.  It is advised for security
reasons to make the configuration file and data directory only readable by the
meow user and group.  Access to meow-cli and other meowd rpc clients
can then be controlled by group membership.

NOTE: When using the systemd .service file, the creation of the aforementioned
directories and the setting of their permissions is automatically handled by
systemd. Directories are given a permission of 710, giving the meowcoin group
access to files under it _if_ the files themselves give permission to the
meowcoin group to do so (e.g. when `-sysperms` is specified). This does not allow
for the listing of files under the directory.

NOTE: It is not currently possible to override `datadir` in
`/etc/meow/meow.conf` with the current systemd, OpenRC, and Upstart init
files out-of-the-box. This is because the command line options specified in the
init files take precedence over the configurations in
`/etc/meow/meow.conf`. However, some init systems have their own
configuration mechanisms that would allow for overriding the command line
options specified in the init files (e.g. setting `RAVEND_DATADIR` for
OpenRC).

### macOS

Binary:              `/usr/local/bin/meowd`  
Configuration file:  `~/Library/Application Support/Meow/meow.conf`  
Data directory:      `~/Library/Application Support/Meow`  
Lock file:           `~/Library/Application Support/Meow/.lock`  

Installing Service Configuration
-----------------------------------

### systemd

Installing this .service file consists of just copying it to
/usr/lib/systemd/system directory, followed by the command
`systemctl daemon-reload` in order to update running systemd configuration.

To test, run `systemctl start meowd` and to enable for system startup run
`systemctl enable meowd`

### OpenRC

Rename meowd.openrc to meowd and drop it in /etc/init.d.  Double
check ownership and permissions and make it executable.  Test it with
`/etc/init.d/meowd start` and configure it to run on startup with
`rc-update add meowd`

### Upstart (for Debian/Ubuntu based distributions)

Drop meowd.conf in /etc/init.  Test by running `service meowd start`
it will automatically start on reboot.

NOTE: This script is incompatible with CentOS 5 and Amazon Linux 2014 as they
use old versions of Upstart and do not supply the start-stop-daemon utility.

### CentOS

Copy meowd.init to /etc/init.d/meowd. Test by running `service meowd start`.

Using this script, you can adjust the path and flags to the meowd program by
setting the RAVEND and FLAGS environment variables in the file
/etc/sysconfig/meowd. You can also use the DAEMONOPTS environment variable here.

### Mac OS X

Copy org.meow.meowd.plist into ~/Library/LaunchAgents. Load the launch agent by
running `launchctl load ~/Library/LaunchAgents/org.meow.meowd.plist`.

This Launch Agent will cause meowd to start whenever the user logs in.

NOTE: This approach is intended for those wanting to run meowd as the current user.
You will need to modify org.meow.meowd.plist if you intend to use it as a
Launch Daemon with a dedicated meow user.

Auto-respawn
-----------------------------------

Auto respawning is currently only configured for Upstart and systemd.
Reasonable defaults have been chosen but YMMV.
