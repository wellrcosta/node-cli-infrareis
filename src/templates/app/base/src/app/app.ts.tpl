import express from "express";
import helmet from "helmet";
import cors from "cors";
import { router as apiRouter } from "../routes";
import { errorHandler } from "../middlewares/error-handler";

export const app = express();

app.use(helmet());
app.use(cors());
app.use(express.json());
app.use(express.urlencoded({ extended: true }));

app.get("/health", (_req, res) => {
  res.json({ status: "ok", timestamp: new Date().toISOString() });
});

// rotas
app.use("/", apiRouter);

// error handler
app.use(errorHandler);
