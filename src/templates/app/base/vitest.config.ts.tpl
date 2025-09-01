import { defineConfig } from "vitest/config";

export default defineConfig({
  test: {
    environment: "node",
    globals: true,
    include: ["tests/**/*.test.ts"],
    reporters: "default",
    coverage: {
      enabled: true,
      reporter: ["text", "lcov"], // gera coverage/lcov.info
      reportsDirectory: "coverage",
      exclude: [
        "dist/**",
        "node_modules/**",
        "tests/**",
        "src/utils/logger.ts"
      ]
    }
  }
});
