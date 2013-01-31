# Changelog

## 1.4.1

* Use unique name when invoking `tomcat7_rhel::tomcat_manager`

  Without the unique name, it is not possible to install multiple applications
  that use Manager.

## 1.4.0

* Add utility script `check_memory_leaks.sh`. It can help you find memory leaks
  in your software.
* Wait at most 80 seconds for the smoke test to pass

## 1.3.0

* Start the Tomcat service after reboot

## 1.2.0

* Rotate Tomcat access logs

## 1.1.1

* Fix dependency error when `tomcat_manager` is set to false
  ([#7](https://github.com/laurilehmijoki/tomcat7_rhel/issues/7))

## 1.1.0

* Add support for the Tomcat parallel deployment feature

## 1.0.0

* Add support for JMX monitoring

* **Break backward compatibility** by converting hypens into underscores (see
  [issue #1](https://github.com/laurilehmijoki/tomcat7_rhel/issues/4) for more
  info).

  You can migrate from previous versions to 1.0.0 by renaming
  invocations of `tomcat7_rhel::tomcat-application` into
  `tomcat7_rhel::tomcat_application`.

## 0.3.3

* Set -XX:MaxPermSize=256m

## 0.3.2

* Check that war file exists before trying to deploy it to tomcat
* Use application name as manager tag instead of tomcat7_rhel

## 0.3.1

* Use `curl -L` in smoke test

## 0.3.0

* Install latest Java 7
* Depend on OpenJDK-devel
* Add smoke test script
* Add Tomcat Manager deployment script

## 0.2.0

* Add support for Tomcat Manager

## 0.1.2

* Add missing dependencies to `tomcat7_rhel::tomcat-application`

## 0.1.1

* Add missing dependencies to `tomcat7_rhel::tomcat-application`

## 0.1.0

* First release
