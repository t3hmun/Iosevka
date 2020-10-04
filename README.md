# Mun Custom Iosevka

This is my custom variant of Iosevka. My commits consist of:

* A `private-build-plans.toml` file, defines my style
* `Dockerfile` and `.dockerignore` I use for building - you wont need node.js on the host system


# How to Build

*Optional* Merge in the latest upstream Iosevka

*Optional* Make more customisations to `private-build-plans.toml`

Now build the docker image.

```powershell
docker build -t iosevka_builder
```

The following things are baked into the image in this order:

* Non-npm build dependencies
* The entire source code
* npm install
* `private-build-plans.toml`

If any of them change, rebuild the image.

Now you can start up the image, bind-mount the output folder.
If you are using bash, swap out `$pwd` for `"$(pwd)"`

```powershell
docker run -it --rm -v $pwd/dist:/build/dist iosevka_builder
```

Finally trigger the build you want.

```bash
npm run build -- contents::mun
```
