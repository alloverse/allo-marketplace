# Alloverse Marketplace

This is the Marketplace app which lets you start other Alloverse apps. The Marketplace
is started automatically in all Alloplaces, so users can start apps and have functionality
in their Places.

The idea is that you'll be able to register and publish your app on my.alloverse.com,
and they'll automatically show up in Marketplace.

Until that functionality exists, apps need to be submoduled into the apps/ directory
in this repo.

## Utilities

### `bootstrap.sh`

Run this to ./allo/assist fetch in all the apps. You need to do this to be able
to start the apps.

### `bump-apps.sh`

Do a cd $app; git pull; cd ..; git add $app for every app in apps/, effectively
updating them all to the latest version.