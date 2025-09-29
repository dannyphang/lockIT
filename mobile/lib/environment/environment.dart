const local = {"log": "http://localhost:1114", "base": "http://localhost:1116"};
const server = {
  "log": "http://localhost:1114",
  "base": "https://mobile-lock-app.vercel.app",
};

const linkServer = true;

final env = {
  'log': linkServer ? server['log'] : local['log'],
  'base': linkServer ? server['base'] : local['base'],
};
