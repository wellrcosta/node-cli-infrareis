import winston from "winston";
// @ts-ignore - tipos podem não expor default
import LokiTransport from "winston-loki";

const transports: winston.transport[] = [
  new winston.transports.Console({
    format: winston.format.combine(
      winston.format.colorize(),
      winston.format.printf(info => `${info.level}: ${info.message}`)
    )
  })
];

const lokiUrl = process.env.LOKI_URL;
if (lokiUrl) {
  try {
    const labelsRaw = process.env.LOKI_LABELS || `{"service":"{{projectName}}","env":"dev"}`;
    const labels = JSON.parse(labelsRaw);
    transports.push(new (LokiTransport as any)({
      host: lokiUrl,
      labels,
      batching: true,
      interval: 5_000,
      json: true
    }));
  } catch (e) {
    // se der erro em labels, continua só com console
    // eslint-disable-next-line no-console
    console.warn("Loki disabled (invalid LOKI_LABELS JSON).", e);
  }
}

export const logger = winston.createLogger({
  level: process.env.LOG_LEVEL || "info",
  format: winston.format.combine(
    winston.format.timestamp(),
    winston.format.errors({ stack: true }),
    winston.format.json()
  ),
  transports
});
