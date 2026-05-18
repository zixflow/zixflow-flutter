<p align=center>
  <a href="https://zixflow.com">
    <img src="https://avatars.githubusercontent.com/u/1152079?s=200&v=4" height="60">
  </a>
</p>

[![Contributor Covenant](https://img.shields.io/badge/Contributor%20Covenant-2.0-4baaaa.svg)](CODE_OF_CONDUCT.md)

# Zixflow Flutter Plugin

This is the official Zixflow Flutter plugin, built on the Customer.io platform.

# Getting started

You'll find our complete [SDK documentation here](https://zixflow.com/docs/sdk/flutter/).

# Installation

Add to your `pubspec.yaml`:

```yaml
dependencies:
  zixflow: ^1.0.0
```

# Quick Start

```dart
import 'package:zixflow/zixflow.dart';

// Initialize the SDK
final config = ZixflowConfig(
  cdpApiKey: 'your-api-key',
  region: Region.US,
  logLevel: CioLogLevel.debug,
);
await Zixflow.initialize(config: config);

// Identify a user
Zixflow.instance.identify(
  userId: 'user-123',
  traits: {'email': 'user@example.com', 'name': 'John Doe'},
);

// Track events
Zixflow.instance.track(
  name: 'purchase_completed',
  properties: {'amount': 99.99, 'product_id': 'ABC123'},
);

// Track screen views
Zixflow.instance.screen(
  title: 'Home Screen',
  properties: {'section': 'main'},
);
```

# Migration from customer_io

This SDK is a rebrand of the Customer.io Flutter plugin. To migrate:

1. **Update `pubspec.yaml`:** Change `customer_io` → `zixflow`
2. **Update imports:** Change `package:customer_io/customer_io.dart` → `package:zixflow/zixflow.dart`
3. **Update class names:**
   - `CustomerIO` → `Zixflow`
   - `CustomerIOConfig` → `ZixflowConfig`

The API surface is identical, only branding has changed.

# Contributing

Thanks for taking an interest in our project! We welcome your contributions.

We value an open, welcoming, diverse, inclusive, and healthy community for this project. We expect all  contributors to follow our [code of conduct](CODE_OF_CONDUCT.md).

# License

[MIT](LICENSE)
