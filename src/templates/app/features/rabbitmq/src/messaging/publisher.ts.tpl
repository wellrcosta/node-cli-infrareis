import { getChannel, queue } from "./rabbit";

export async function publishMessage(msg: any) {
  const ch = await getChannel();
  ch.sendToQueue(queue, Buffer.from(JSON.stringify(msg)), { persistent: true });
}
