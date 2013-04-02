# Changelog

## 2.3.0

* Add possibility to define path for smoke test

## 2.2.0

* Add custom XML into the `<Engine>` tag of `server.xml`
* Use real user IP also in access log

## 2.1.0

* Log the request processing time into access log
* Do not rotate logs on Tomcat, let `logrotate` do that
* Start using `RemoteIpValve`
* In `server.xml`, add double quotes around `rotatable`
* In `server.xml`, remove extra '.' from access log filename

## 2.0.2

* Make curl silent (-s) in tomcat manager deploy & undeploy

## 2.0.1

* Add --fail param to the `curl` calls

  Before this, the `curl` did not fail even though Tomcat Manager was missing.

## 2.0.0

* Remove default JVM parameters

  **This change breaks the backward compatibility.**

  Before, the default parameters where these: `-server -Xmx1024m -Xms128m
  -XX:MaxPermSize=256m`. From now on, you need to define all the JVM parameters.
  You can migrate by adding e.g., `-server -Xmx1024m -Xms128m
  -XX:MaxPermSize=256m` into the `jvm_envs` param of the
  `tomcat7_rhel::tomcat_application` invocation.

* Rename `tomcat7_rhel::tomcat_application` params `jmxRegistryPort` =>
  `jmx_registry_port` and `jmxServerPort` => `jmx_server_port`

  **This change breaks the backward compatibility.** Migrate by renaming the
  variables in your `tomcat7_rhel::tomcat_application` invocations.

* Infer Tomcat control port from the HTTP port (default: HTTP port + 1000)

## 1.4.3

* Fix dependency cycle problem when installing Tomcat Manager

## 1.4.2

* Declare Package['tomcat7-admin-webapps'] only once

  Before, the package was declared as many times as
  `tomcat7_rhel::tomcat_manager` was called. This made it impossible to install
  multiple applications that use Manager.

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
