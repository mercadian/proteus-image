# proteus-image

This repo holds everything you need to build the OS image for the Proteus.


## About the Image

The Proteus uses Debian 11 (Bullseye) as its base operating system. The configuration is based on Radxa's own [stock image](https://github.com/radxa-build/rock-5b/releases/), but customized to be ready to run a Rocket Pool node out of the box.

It includes:
- Radxa's variant of the v5.10.66 Linux kernel for the Rock 5B
- The requisite OS packages, and some bonus packages useful for node operation such as `lm-sensors` and `jq`
- Docker and docker-compose
- The Rocket Pool Smartnode software (v1.6.0 is currently installed, which may not be the latest - see [the releases page](https://github.com/rocket-pool/smartnode-install/releases/latest) to check if there is an update)
- Proteus-specific device tree overlays, which are necessary for the front panel and activity LED to function correctly


## Prerequisites

Building the image and the other artifacts is done within a Docker container for convenience. It contains all of the requisite tools and cross-platform compilers, so it works on typical x64 systems. This image is hosted here on Docker Hub:

https://hub.docker.com/r/mercadian/proteus-build

If you want to create the builder image yourself rather than downloading the pre-built one, you can do so with the following command:

```
docker build -t mercadian/proteus-build:latest .
```

The configuration for it can be found in the [Dockerfile](./Dockerfile)


## Building the Image

Building the image involves the following steps:

- (Optional) Build the [Proteus device tree overlay package](https://github.com/mercadian/proteus-overlay-pkg/)
- (Optional) Build the bootloader
- (Optional) Build the kernel
- Build the OS image

The repository already contains the first three artifacts for convenience, but you can rebuild them from source. The steps for each one are listed below.


### (Optional) Building the Device Tree Overlay Package

The DTO package is a Debian package that contains:
- The device tree overlay for the Proteus, which modifies the activity LED pin from its original value to the pin that the front panel LED uses
- The scripts and hooks that update the bootloader configuration to include this overlay whenever a new kernel is installed

To build it, run the following command:

```
./build.sh -p
```

This will create a file called `proteus-overlay-pkg/out/proteus-overlay_<version>_arm64.deb` and copy it into the image source's kernel package directory (`radxa/debos/rootfs/packages/arm64/kernel`).

Note that this package will **not be signed** if you build it manually.


### (Optional) Building the Bootloader

The Rock 5B uses [U-Boot](https://www.denx.de/wiki/U-Boot/) as its bootloader. The Proteus uses the [stock bootloader that Radxa maintains](https://github.com/radxa/u-boot/tree/stable-5.10-rock5), which is a modified version of mainline U-Boot.

This repository includes the Radxa U-Boot repository as a submodule. While it is tagged with a commit that the production image was built with, you may want to update it to the latest commit before building. You can do it with the following:

```
cd radxa/u-boot && git pull; cd ../..
```

To build the booloader image and packages:

```
./build.sh -u
```

This will create a file called `radxa/out/packages/rock-5b-rk-ubootimg_<version>.deb` and copy it into the image source's bootloader package directory (`radxa/debos/rootfs/packages/arm64/u-boot/`).


### (Optional) Building the Kernel

The Proteus uses the [stock Radxa Rock 5B kernel](https://github.com/radxa/kernel/tree/stable-5.10-rock5), which is a modified version of the Linux 5.10.66 kernel.

This repository includes the Radxa Kernel repository as a submodule. While it is tagged with a commit that the production image was built with, you may want to update it to the latest commit before building. You can do it with the following:

```
cd radxa/kernel && git pull; cd ../..
```

To build the kernel packages:

```
./build.sh -k
```

This will create several files in `radxa/out/packages/` called `linux-headers-<version>.deb` and `linux-image-<version>.deb`. It will then remove all of the old 5.10.66 kernel packages from the image source's kernel directory (`radxa/debos/rootfs/packages/arm64/kernel/`) and copy these new packages into it.

**NOTE:** This will also include the debug kernel, which is much larger than the standard kernel. **If you don't need it, you may want to remove this from the image source directory manually before building the OS image.**


### Building the OS Image

The build system uses [debos](https://github.com/go-debos/debos) to build the system image for the Proteus. It contains a [customized fork](https://github.com/mercadian/radxa-debos) of the stock debos configuration that Radxa maintains for building its own images for the Rock line.

To build the OS image:

```
./build.sh -i
```

This will take some time, but eventually produce a flashable image file called `radxa/debos/output/rock-5b-debian-bullseye-server-arm64-<date>-gpt.img.xz`.


## Flashing the Image to the Proteus

To flash the image to Proteus, it is recommended to follow [this guide](https://github.com/mercadian/proteus/wiki/Flashing-the-Image).
