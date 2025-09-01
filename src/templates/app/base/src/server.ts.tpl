import dotenv from "dotenv";
import { createServer } from "http";
import { app } from "./app/app";
import { logger } from "./utils/logger";

dotenv.config();

const PORT = Number(process.env.PORT || 3000);
const server = createServer(app);

server.listen(PORT, () => {
  logger.info(`Server running on port ${PORT}`);
});