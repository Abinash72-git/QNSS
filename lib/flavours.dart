enum Flavor { dev, prod, demo }

class F {
  static Flavor? appFlavor;

  static String get name => appFlavor?.name ?? '';

  static String get title {
    switch (appFlavor) {
      case Flavor.dev:
        return 'FulupoUMS Dev';
      case Flavor.prod:
        return 'FulupoUMS';
      case Flavor.demo:
        return 'FulupoUMS Demo';
      default:
        return 'title';
    }
  }
}
