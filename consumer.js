// var WebSocketServer = require("websocket").server;
var http = require("http");
const pid = process.pid;
const { Kafka } = require("kafkajs");

const kafka = new Kafka({
  clientId: "test",
  brokers: ["0.tcp.ngrok.io:15605"],
});

const consumer = kafka.consumer({ groupId: "mqtt-gp-consumer" });

async function initKafka() {
  await consumer.connect();
  await consumer.subscribe({ topic: "mqtt", fromBeginning: false });

  await consumer
    .run({
      eachMessage: async ({ topic, partition, message }) => {
        console.log({
          value: message.value.toString(),
        });
      },
    })
    .then(console.log);
}

initKafka().catch(console.error);

var server = http.createServer(function (request, response) {
  console.log(" Request recieved : " + request.url);
  response.writeHead(200);
  response.end();
});
server.listen(9098, function () {
  console.log("Listening on port : 8080");
});
