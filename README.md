Creates a Docker image that contains a build of the current development
version of GNU Octave.

## Implementation Details

Because of the resources needed to compile Octave from source, it is
impractical to build it using the Docker Hub's automated build service.

Therefore, the following procedure is used

1. Octave is compiled in a local virtual machine using Vagrant

2. Octave binary payload is pulled from the VM, archived, and uploaded

3. Docker image is rebuilt on Docker Hub
