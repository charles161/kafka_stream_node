var http = require("http");
const kafka = require("kafka-node");

const kafkaClientOptions = { sessionTimeout: 100, spinDelay: 100, retries: 2 };
const kafkaClient = new kafka.Client(
  "2.tcp.ngrok.io:10345",
  "producer-client",
  kafkaClientOptions
);
const kafkaProducer = new kafka.HighLevelProducer(kafkaClient);

kafkaClient.on("error", (error) => console.error("Kafka client error:", error));
kafkaProducer.on("error", (error) =>
  console.error("Kafka producer error:", error)
);

setInterval(() => {
  const payload = [
    {
      topic: "mqtt",
      messages: [
        {
          value: "it is cool",
        },
      ],
      attributes: 1,
    },
  ];

  kafkaProducer.send(payload, function (error, result) {
    console.info("Sent payload to Kafka:", payload);
    if (error) {
      console.error("Sending payload failed:", error);
    } else {
      console.log("Sending payload result:", result);
    }
  });
}, 5000);

var server = http.createServer(function (request, response) {
  console.log(" Request recieved : " + request.url);
  response.writeHead(200);
  response.end();
});
server.listen(9099, function () {
  console.log("Listening on port : 9099");
});
