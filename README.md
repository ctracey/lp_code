
LP Batch Processor
==================

This gem is executable.
It reads in a XML file with destination content and another XML file with destination taxonomy definition.
It saves all generated files to ./output directory

run this command to learn more

```
bundle exec rake -T
```

Dependencies
------------

This gem is build using Ruby 2.0.0
Run this command to install dependencies
```
bundle install
```

Running the specs
-----------------

Run this command to run all the specs

```
bundle exec rake spec
```

Building
--------

ci task runs the automated tests, builds the gem and installs the gem locally
```
bundle exec rake ci
```

Running the batch processor
---------------------------

After you have build and installed the gem you can run the batch processor

### Help
run this command to get help
```
batch_processor -h
```

### Example:
```
batch_processor spec/fixtures/destinations.xml spec/fixtures/taxonomy.xml
```


