// 檔案：android/build.gradle.kts
import java.util.Properties
import java.io.FileInputStream

plugins {
    // 這裡通常是空的，或者由 Flutter 自動管理
}

// ✨ 我們讓「長官」來讀取密碼檔案 ✨
val keystorePropertiesFile = rootProject.file("key.properties")
val keystoreProperties = Properties()
keystoreProperties.load(FileInputStream(keystorePropertiesFile))
// ✨ 並將讀取到的密碼，存放在一個大家都能存取的「公佈欄」上 ✨
rootProject.extra.set("keystoreProperties", keystoreProperties)

allprojects {
    repositories {
        google()
        mavenCentral()
    }
}

// ... 您原本的其他內容可以保持不變或直接使用這個版本 ...
val newBuildDir: Directory =
    rootProject.layout.buildDirectory
        .dir("../../build")
        .get()
rootProject.layout.buildDirectory.value(newBuildDir)

subprojects {
    val newSubprojectBuildDir: Directory = newBuildDir.dir(project.name)
    project.layout.buildDirectory.value(newSubprojectBuildDir)
}

tasks.register<Delete>("clean") {
    delete(rootProject.layout.buildDirectory)
}