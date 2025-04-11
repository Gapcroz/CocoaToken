import { Request } from 'express';
import { Model } from 'sequelize';

declare global {
  namespace Express {
    interface Request {
      user?: Model<any, any>;
    }
  }
} 