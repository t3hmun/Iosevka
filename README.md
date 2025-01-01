My custom variant of Iosevka, called Mun. It is just the mun.toml file.
Mainly created to make sure `iIlL1|oO0` all obivious and different.


This doesn't need to be a fork anymore, just need the toml file and the docker dir from Iosevka main.

```bash
git clone --depth=1 https://github.com/t3hmun/Iosevka munfont
cd munfont
podman build -t munfont ./docker
cd mun
podman run -it --rm -v $(pwd -W):/work -e munfont contents::Mun
```

## Troubleshooting

If you get an error like this:

`Error: Error: Composite {user} cannot be resolved: five,upright-arched.`

- grep the repo for that variant (just `upright-arched` in this case) 
- You should find an entry in the changes archive that will tell you what it was renamed to. 
- Search the new name again to make sure it was not renamed again.
- Update the toml file with the new name.
