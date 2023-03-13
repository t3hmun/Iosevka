# mun

Created using [Iosevka's](https://github.com/be5invis/Iosevka) customisation feature.

Version 21.0.0 is based on the 21.0.0 release of Iosevka.

Built using the [avivace/iosevka-docker](https://github.com/avivace/iosevka-docker).

Just running the container didn't seem to work. Steps used to build:

* `git clone https://github.com/avivace/fonts-iosevka.git`
* `docker build -t iosevka_build . -f Dockerfile`
* Put my `private-build-plans.toml` in `./build/`
* `docker run -e FONT_VERSION=21.0.0 -it -v $(pwd)/build:/build iosevka_build`
* Computer gets warm.
* Copy out the result from `./build/dist/`