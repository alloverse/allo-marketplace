# Alloverse Marketplace

This is the Marketplace app which lets you start other Alloverse apps. The Marketplace
is started automatically in all Alloplaces, so users can start apps and have functionality
in their Places.

The idea is that you'll be able to register and publish your app on my.alloverse.com,
and they'll automatically show up in Marketplace.

Until that functionality exists, apps need to be submoduled into the apps/ directory
in this repo.

In this configuration, the `serve` script MUST run on the same machine as Marketplace
like so:

```
    env APPS_ROOT=./apps/ python3 allo/serve.py
```

and in another terminal tab, start Marketplace into the server where you want it:

```
    ./allo/assist run alloplace://sandbox.places.alloverse.com
```

## Utilities

### `scripts/bootstrap.sh`

Run this to ./allo/assist fetch in all the apps. You need to do this to be able
to start the apps.

### Upgrading apps and their dependencies

There are three upgrade scripts, of varying levels:

* `bash scripts/bump-apps.sh` pulls the latest commit in every app, but doesn't modify
  the apps themselves
* `bash scripts/upgrade-apps.sh` does that, plus fetches the latest allonet and alloui
  in each, plus makes a commit for the upgrade (but doesn't push them)
* `bash scripts/upgrade-assists.sh` does that, plus upgrades boot and assist too.

How to use:

1. Make sure your working copy of marketplace and all its submodules are completely clean
2. Run the upgrade script of choice
3. Test all the apps to make sure they work after
4. If using second or third upgrade script: `bash scripts/push-apps.sh`
5. `git commit -m 'bump all apps'`
6. `git push`
