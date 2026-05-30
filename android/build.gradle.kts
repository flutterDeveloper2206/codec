allprojects {
    repositories {
        google()
        mavenCentral()
    }
}

val newBuildDir: Directory =
    rootProject.layout.buildDirectory
        .dir("../../build")
        .get()
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

subprojects {
    if (project.name == "assets_audio_player_web") {
        project.tasks.configureEach {
            if (name.contains("compile", ignoreCase = true)) {
                enabled = false
            }
        }
    }
    val configureProject = {
        val android = project.extensions.findByName("android")
        if (android != null) {
            try {
                val getCompileSdk = android.javaClass.getMethod("getCompileSdk")
                val setCompileSdk = android.javaClass.getMethod("setCompileSdk", Int::class.java)
                val currentSdk = getCompileSdk.invoke(android) as? Int
                if (currentSdk == null || currentSdk < 36) {
                    setCompileSdk.invoke(android, 36)
                }
            } catch (e: Exception) {
                try {
                    val getCompileSdkVersion = android.javaClass.getMethod("getCompileSdkVersion")
                    val setCompileSdkVersion = android.javaClass.getMethod("setCompileSdkVersion", Int::class.java)
                    val currentSdk = getCompileSdkVersion.invoke(android) as? Int
                    if (currentSdk == null || currentSdk < 36) {
                        setCompileSdkVersion.invoke(android, 36)
                    }
                } catch (e2: Exception) {
                    // Ignore
                }
            }
            try {
                val getNamespace = android.javaClass.getMethod("getNamespace")
                val setNamespace = android.javaClass.getMethod("setNamespace", String::class.java)
                val currentNamespace = getNamespace.invoke(android)
                if (currentNamespace == null) {
                    val cleanName = project.name.replace("-", "_").replace(".", "_")
                    val groupStr = project.group.toString()
                    val fallbackGroup = if (groupStr.isNotEmpty()) groupStr else "com.example"
                    val ns = if (project.name == "flutter_bluetooth_serial") {
                        "io.github.edufolly.flutterbluetoothserial"
                    } else {
                        "$fallbackGroup.$cleanName"
                    }
                    setNamespace.invoke(android, ns)
                    println("Injected namespace '$ns' into project '${project.name}'")
                }
            } catch (e: Exception) {
                // Ignore
            }
        }
    }

    if (project.state.executed) {
        configureProject()
    } else {
        project.afterEvaluate {
            configureProject()
        }
    }
}
