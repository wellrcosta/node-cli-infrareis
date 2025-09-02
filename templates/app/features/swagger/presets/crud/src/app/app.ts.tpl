import express from "express";
import helmet from "helmet";
import cors from "cors";
import { errorHandler } from "../middlewares/error-handler";
import { router as rootRouter } from "../routes";
import { router as users } from "../routes/users.routes";
import { applySwagger } from "../docs/swagger";

export const app = express();

app.use(helmet());
app.use(cors());
app.use(express.json());
app.use(express.urlencoded({ extended: true }));

app.get("/health", (_req, res) => {
  res.json({ status: "ok", timestamp: new Date().toISOString() });
});

app.use("/", rootRouter);
app.use("/api/users", users);

// habilita Swagger em /docs e /docs.json
applySwagger(app);

app.use(errorHandler);
