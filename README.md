# Template for Satin & Forge & Youi

## Getting Started

Install Bundler using:

```
[sudo] gem install bundler
```

Install the Bundler dependencies specified in the Gemfile:

```
bundle config set path vendor/bundle
bundle install
```

Finally, install the CocoaPod dependencies using Bundler:

```
bundle exec pod install
```
