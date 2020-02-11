# AudioWidget demo

This app demonstrates how the AudioWidget could be used. The library only includes a simple widget, but there are any number of ways it could be used. Here are a few points about how this demo is set up:

- An MVVM architecture is used to communicate with the AudioWidget. See [this article](https://medium.com/flutter-community/a-beginners-guide-to-architecting-a-flutter-app-1e9053211a74) for a more detailed description.
- You can use any audio plugin you like, but this demo uses the [audioplayers](https://pub.dev/packages/audioplayers) plugin.
- The `audioplayers` plugin is hidden behind a service class. This allows you to switch to a different plugin later if you like. Read [this article](- You can use any audio plugin you like, but this demo uses the [audioplayers](https://pub.dev/packages/audioplayers) plugin.
) for more about using a service architecture.

