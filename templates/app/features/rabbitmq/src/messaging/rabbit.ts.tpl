import amqp from "amqplib";

let connection: amqp.Connection | null = null;
let channel: amqp.Channel | null = null;

const url = process.env.RABBITMQ_URL || "amqp://guest:guest@localhost:5672";
const queue = process.env.RABBITMQ_QUEUE || "{{projectName}}-queue";

export async function getChannel() {
  if (channel) return channel;
  connection = await amqp.connect(url);
  channel = await connection.createChannel();
  await channel.assertQueue(queue, { durable: true });
  return channel;
}

export async function closeConnection() {
  if (channel) await channel.close();
  if (connection) await connection.close();
  channel = null;
  connection = null;
}

export { queue };