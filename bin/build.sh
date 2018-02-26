#!/bin/bash

carthage checkout
mv Carthage/Checkouts/reddift/test/test_config.json{.sample,}
carthage build --platform ios
