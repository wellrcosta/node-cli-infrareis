import { Router } from "express";

export const router = Router();

/**
 * @openapi
 * /:
 *   get:
 *     summary: Mensagem de boas-vindas
 *     tags: [Root]
 *     responses:
 *       200:
 *         description: Retorna uma mensagem de boas-vindas
 *         content:
 *           application/json:
 *             schema:
 *               type: object
 *               properties:
 *                 message:
 *                   type: string
 */
router.get("/", (_req, res) => {
  res.json({ message: "Welcome to API (minimal)" });
});
