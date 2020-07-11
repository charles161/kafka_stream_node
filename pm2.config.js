module.exports = [
  {
    script: "index.js",
    name: "eventprocessor",
    exec_mode: "cluster",
    instances: 2,
  },
];
