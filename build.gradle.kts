plugins {
    java
    war
}
group = "org.orbeon.session"
version = "0.0.1-SNAPSHOT"
java.sourceCompatibility = JavaVersion.VERSION_11

repositories {
        mavenCentral()
}

var tomcatVersion = "10.1.8"
dependencies {
    compileOnly("org.apache.tomcat:tomcat-catalina:${tomcatVersion}")
    compileOnly("org.apache.tomcat:tomcat-tribes:${tomcatVersion}")
    implementation("org.redisson:redisson:3.21.3")
    implementation("org.redisson:redisson-tomcat-10:3.21.3")
}