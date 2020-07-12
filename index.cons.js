// var WebSocketServer = require("websocket").server;
var http = require("http");
const pid = process.pid;
const { Kafka } = require("kafkajs");

const kafka = new Kafka({
  clientId: "my-app",
  brokers: ["broker:29092"],
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
  }, 10000);

  // await producer.disconnect();
}

initKafka().catch(console.error);

var server = http.createServer(function (request, response) {
  console.log(" Request recieved : " + request.url);
  response.writeHead(200);
  response.end();
});
server.listen(9099, function () {
  console.log("Listening on port : 8080");
});
