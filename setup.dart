import 'dart:convert';
import 'dart:developer';
import 'dart:io';

void main() async {
  try {
    // Path to the setup.json file
    final setupFilePath = 'setup.json';

    // Check if the setup.json file exists
    final file = File(setupFilePath);
    if (!file.existsSync()) {
      log("Error: setup.json file not found.");
      return;
    }

    // Read and parse the JSON data from setup.json
    final data = jsonDecode(await file.readAsString());

    // Create directories if specified in the JSON
    if (data.containsKey("folders")) {
      for (var path in data["folders"]) {
        final directory = Directory(path);
        if (!directory.existsSync()) {
          directory.createSync(recursive: true);
          log("Created directory: $path");
        }
      }
    }

    // Create files if specified in the JSON
    if (data.containsKey("files")) {
      final files = data["files"];
      files.forEach((path, content) {
        final file = File(path);
        if (!file.existsSync()) {
          file.createSync(recursive: true);
          file.writeAsStringSync(content);
          log("Created file: $path");
        }
      });
    }

    // Install dependencies if specified in the JSON
    if (data.containsKey("packages")) {
      List<String> dependencies = List<String>.from(data["packages"]);
      if (dependencies.isNotEmpty) {
        for (var package in dependencies) {
          var result = Process.runSync("dart", ["pub", "add", package]);
          if (result.exitCode == 0) {
            log("Added dependency: $package");
          } else {
            log("Error adding dependency $package: ${result.stderr}");
          }
        }
      }
    }

    // Install dev dependencies if specified in the JSON
    if (data.containsKey("dev_dependencies")) {
      List<String> devDependencies = List<String>.from(
        data["dev_dependencies"],
      );
      if (devDependencies.isNotEmpty) {
        for (var package in devDependencies) {
          var result = Process.runSync("dart", [
            "pub",
            "add",
            "--dev",
            package,
          ]);
          if (result.exitCode == 0) {
            log("Added dev dependency: $package");
          } else {
            log("Error adding dev dependency $package: ${result.stderr}");
          }
        }
      }
    }

    // Run flutter pub get to fetch all dependencies
    var result = Process.runSync("flutter", ["pub", "get"]);
    if (result.exitCode == 0) {
      log("Flutter project setup completed successfully!");
    } else {
      log("Error running flutter pub get: ${result.stderr}");
    }
  } catch (e) {
    log("Error: $e");
  }
}
