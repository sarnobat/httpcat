# httpcat
netcat that accepts http requests

A "microservice" / unix philosophy rearchitecture of yurl


### native image problem

It fails at runtime
```
Exception in thread "main" java.lang.NoClassDefFoundError: org.glassfish.jersey.internal.OsgiRegistry
	at org.glassfish.jersey.internal.util.ReflectionHelper.getOsgiRegistryInstance(ReflectionHelper.java:1492)
	at org.glassfish.jersey.internal.ServiceFinder.<clinit>(ServiceFinder.java:142)
	at com.oracle.svm.core.hub.ClassInitializationInfo.invokeClassInitializer(ClassInitializationInfo.java:350)
	at com.oracle.svm.core.hub.ClassInitializationInfo.initialize(ClassInitializationInfo.java:270)
	at java.lang.Class.ensureInitialized(DynamicHub.java:499)
	at org.glassfish.jersey.internal.inject.Injections.lookupService(Injections.java:88)
	at org.glassfish.jersey.internal.inject.Injections.lookupInjectionManagerFactory(Injections.java:73)
	at org.glassfish.jersey.internal.inject.Injections.createInjectionManager(Injections.java:69)
	at org.glassfish.jersey.server.ApplicationHandler.<init>(ApplicationHandler.java:261)
	at org.glassfish.jersey.server.ApplicationHandler.<init>(ApplicationHandler.java:236)
	at org.glassfish.jersey.jdkhttp.JdkHttpHandlerContainer.<init>(JdkHttpHandlerContainer.java:72)
	at org.glassfish.jersey.jdkhttp.JdkHttpServerFactory.createHttpServer(JdkHttpServerFactory.java:84)
	at org.glassfish.jersey.jdkhttp.JdkHttpServerFactory.createHttpServer(JdkHttpServerFactory.java:66)
	at com.HttpCatPure.main(HttpCatPure.java:50)
```