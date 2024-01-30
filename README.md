# docker-seiscomp

Run SeiscomP services in a Docker container

## SeiscomP base image

The SeiscomP base image is the base for the services described below. The image is based on Debian/Bookworm (12). It installs SeiscomP from `.tgz` file matching the used Debian version and all required dependencies. The services are run with the user `sysop`.

Use `docker build --rm --tag seiscomp --target seiscomp .` to build this image. This step is optional.

## SeiscomP Helix Plotter (scheli)

The `Dockerfile` also provides instructions to create an image to run `scheli` as a service.

This is build with `docker build --rm --tag scheli --target scheli .`.

### Usage

The image uses the environment variables

* `SLINK_HOST` host of a Seedlink server to use (default `localhost`)
* `SC_HOST` host to connect to (default `localhost`)
* `DEBUG` set to value `--debug` if you need debugging output (default `` (empty))
* `INVENTORY` to specify a file containing the inventory (default `inventory.xml`)
* `INTERVAL` to specify the interval between updates of the images (default `30`)
* `XRES` and `YRES` to specify the x and y resolution of the images (default `1024` x `768`)
* `TEMPLATE` to specify a template string for the image's filename (default `%N/%S.png`)

to setup the scheli service. The generated files are stored in the directory `output` which can be a docker volume (e.g. `$(pwd)/output:/home/sysop/output:rw`). Additional options can be given in the file `etc/scheli.cfg` which is copied to the image at build time or in docker volume mounted at `/home/sysop/.seiscomp/scheli.cfg` (see next paragraph)

See the `scheli` documentation for more info on the options. The inventory file should be made available a docker volume (e.g `-v $(pwd)/inventory.xml:/home/sysop/inventory.xml:ro`). The **streams** and additional options should be specified in a configuration file `.seiscomp/scheli.cfg` also as a docker volume (e.g. `-v $(pwd)/scheli.cfg:/home/sysop/.seiscomp/scheli.cfg:ro`). Use the config value `heli.streams` to configure the streams to capture.
