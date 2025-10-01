import 'package:flutter/foundation.dart';

const local = {"log": "http://localhost:1114", "base": "http://localhost:1116"};
const server = {
  "log": "http://localhost:1114",
  "base": "https://mobile-lock-app.vercel.app",
};

const linkServer = false;

final env = {
  'log': kReleaseMode || linkServer
      ? "http://localhost:1114"
      : "http://localhost:1114",
  'base': kReleaseMode || linkServer
      ? "https://mobile-lock-app.vercel.app"
      : "http://localhost:1116",
};
