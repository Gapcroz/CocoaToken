import { Sequelize } from "sequelize";
import dotenv from "dotenv";

dotenv.config();

// Check that all required environment variables are defined
const requiredEnvVars = [
  "DB_NAME",
  "DB_USER",
  "DB_PASSWORD",
  "DB_HOST",
  "DB_INSTANCE",
];
for (const envVar of requiredEnvVars) {
  if (!process.env[envVar]) {
    throw new Error(`Environment variable ${envVar} is not defined`);
  }
}

const sequelize = new Sequelize(
  process.env.DB_NAME!,
  process.env.DB_USER!,
  process.env.DB_PASSWORD!,
  {
    dialect: "mssql",
    host: process.env.DB_HOST!,
    dialectOptions: {
      instanceName: process.env.DB_INSTANCE!,
      options: {
        encrypt: false,
        trustServerCertificate: true,
      },
    },
    logging: false,
    pool: {
      max: 5,
      min: 0,
      acquire: 30000,
      idle: 10000,
    },
  }
);

export default sequelize;
