import { getChannel, queue } from "./rabbit";

export async function consumeMessages(handler: (msg: any) => Promise<void>) {
  const ch = await getChannel();
  await ch.consume(queue, async (msg) => {
    if (!msg) return;
    try {
      const payload = JSON.parse(msg.content.toString());
      await handler(payload);
      ch.ack(msg);
    } catch (err) {
      console.error("Erro ao processar mensagem:", err);
      ch.nack(msg, false, false);
    }
  });
}
