# Changelog

## 1.0.0

* Add support for JMX monitoring

* **Break backward compatibility** by converting hypens into underscores (see
  [issue #1](https://github.com/laurilehmijoki/tomcat7_rhel/issues/4) for more
  info).

  Migrate from previous versions to 1.0.0 by renaming
  `tomcat7_rhel::tomcat-application` into `tomcat7_rhel::tomcat_application`.

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
