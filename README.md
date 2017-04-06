Creates a Docker image that contains a build of the current development
version of [GNU Octave](http://www.octave.org).

Image is available on Docker Hub at
[mtmiller/octave-snapshot](https://hub.docker.com/r/mtmiller/octave-snapshot).

# Quick Start

1. Create a Docker image derived from `mtmiller/octave-snapshot`, or just
   `docker run -it mtmiller/octave-snapshot`.
2. Use Octave or build your project against it.
3. Profit.

# License

The scripts in this repository are licensed under a modified BSD license.
See [LICENSE.md](LICENSE.md) for the full license text.

## Implementation Details

Because of the resources needed to compile Octave from source, it is
impractical to build it using the Docker Hub's automated build service.

Therefore, the following procedure is used

1. Octave is compiled in a local virtual machine using Vagrant

2. Octave binary payload is pulled from the VM, archived, and uploaded

3. Docker image is rebuilt on Docker Hub
