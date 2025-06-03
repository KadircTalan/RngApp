allprojects {
    repositories {
        google()
        mavenCentral()
    }
}

val newBuildDir: Directory = rootProject.layout.buildDirectory.dir("../../build").get()
rootProject.layout.buildDirectory.value(newBuildDir)

subprojects {
    val newSubprojectBuildDir: Directory = newBuildDir.dir(project.name)
    project.layout.buildDirectory.value(newSubprojectBuildDir)
}
subprojects {
    project.evaluationDependsOn(":app")
}

tasks.register<Delete>("clean") {
    delete(rootProject.layout.buildDirectory)
}
// ...
plugins {
    // Buraya diğer pluginler (varsa) ve Google Services eklentisini **tek seferde** ekle!
    id("com.google.gms.google-services") version "4.3.15" apply false
    // id("başka.bir.plugin") version "x.y.z"
}
