Contributing to Shift Circuit Breaker
=====================

Feel free to contribute to the project by submitting a [pull request](https://github.com/shiftcommerce/shift-circuit-breaker/pulls) or [proposing features and discuss issues](https://github.com/shiftcommerce/shift-circuit-breaker/issues).

#### Fork the Project

Fork the [project on Github](https://github.com/shiftcommerce/shift-circuit-breaker) and check out your copy.

```
$ git https://github.com/shiftcommerce/shift-circuit-breaker.git
$ cd shift-circuit-breaker
$ git remote add upstream https://github.com/shiftcommerce/shift-circuit-breaker.git
```

#### Create a Branch

Make sure your fork is up-to-date and create a branch for your feature or bug fix.

```
git checkout master
git pull upstream master
git checkout -b my-feature-branch
```

#### Bundle Install and Run Specs

Ensure that you can build the project and run specs successfully before starting.

```
$ bundle install
$ bundle exec rspec
```

#### Write Tests

Please make sure that there is test coverage for the changes made /or issue fixed.

#### Write Code

Implement your feature or bug fix and make sure that specs complete without errors.

#### Write Documentation

Update the documentation as per the changes made in the [README](README.md).

#### Commit Changes

Please write good commit logs. A commit log should describe what changed and why.

```
$ git add ...
$ git commit
```

#### Push Changes

```
$ git push origin my-feature-branch
```

#### Make a Pull Request

Visit your forked repo and click the 'New pull request' button. Select your feature branch, fill out the form, and click the 'Create pull request' button.

#### Rebase

If you have been working on a change for a while, rebase with upstream/master.

```
$ git fetch upstream
$ git rebase upstream/master
$ git push origin my-feature-branch -f
```

#### Pull Request Review

The team will review the pull request. In the case that a change request has been made, please update please update the PR in order for the feature or bug fix to be merged. 
