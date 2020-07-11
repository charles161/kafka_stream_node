var WebSocketServer = require("websocket").server;
var http = require("http");
const pid = process.pid;
const { Kafka } = require("kafkajs");

const kafka = new Kafka({
  clientId: "my-app",
  brokers: ["localhost:9092"],
});

const consumer = kafka.consumer({ groupId: "mqtt-cool" });

async function initKafka() {
  await consumer.connect();
  await consumer.subscribe({ topic: "mqtt", fromBeginning: false });

  await consumer.run({
    eachMessage: async ({ topic, partition, message }) => {
      console.log({
        value: message.value.toString(),
      });
    },
  });

  const producer = kafka.producer();

  await producer.connect();

  setInterval(async () => {
    await producer.send({
      topic: "mqtt",
      messages: [{ value: "Hello KafkaJS user!" }],
    });
  }, 3000);

  // await producer.disconnect();
}

initKafka().catch(console.error);

var server = http.createServer(function (request, response) {
  console.log(" Request recieved : " + request.url);
  response.writeHead(404);
  response.end();
});
server.listen(8080, function () {
  console.log("Listening on port : 8080");
});

webSocketServer = new WebSocketServer({
  httpServer: server,
  autoAcceptConnections: false,
});

function iSOriginAllowed(origin) {
  return true;
}

webSocketServer.on("request", function (request) {
  if (!iSOriginAllowed(request.origin)) {
    request.reject();
    console.log(" Connection from : " + request.origin + " rejected.");
    return;
  }

  var connection = request.accept("echo-protocol", request.origin);
  console.log(" Connection accepted : " + request.origin);
  connection.on("message", function (message) {
    if (message.type === "utf8") {
      console.log("Received Message: " + message.utf8Data);
    }
  });
  //   consumer.on("message", function (message) {
  //     console.log(message);
  //     connection.sendUTF(message.value);
  //   });
  connection.on("close", function (reasonCode, description) {
    console.log("Connection " + connection.remoteAddress + " disconnected.");
  });
});
