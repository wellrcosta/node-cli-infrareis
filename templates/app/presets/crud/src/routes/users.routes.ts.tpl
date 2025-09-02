import { Router } from "express";
import * as controller from "../controllers/users.controller";

export const router = Router();

router.get("/", controller.list);
router.get("/:id", controller.getById);
router.post("/", controller.create);
router.put("/:id", controller.update);
router.delete("/:id", controller.remove);