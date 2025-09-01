import dotenv from "dotenv";
dotenv.config();

import "./repositories/index";

import { createServer } from "http";
import { app } from "./app/app";
import { logger } from "./utils/logger";

const PORT = Number(process.env.PORT || 3000);
const server = createServer(app);

server.listen(PORT, () => {
  logger.info(`Server running on port ${PORT}`);
});
