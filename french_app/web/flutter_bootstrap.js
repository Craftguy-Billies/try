// Copyright 2014 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

// This is the entrypoint for the custom flutter web bootstrap.
// It initializes the Flutter engine and loads the main.dart.js file.

"use strict";

// This loads the flutter engine JavaScript and the service worker.
// The `{{flutter_js}}` and `{{flutter_build_config}}` are replaced
// by `flutter build web` with the actual file contents.
{{flutter_js}}
{{flutter_build_config}}

// This is the entrypoint that loads the main.dart.js file.
_flutter.loader.load({
  onEntrypointLoaded: async function(engineInitializer) {
    const appRunner = await engineInitializer.initializeEngine({
      useColorEmoji: true,
    });
    await appRunner.runApp();
  }
});
