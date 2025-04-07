import express, { Express } from 'express';
import cors from 'cors';
import sequelize from './config/database';

const app: Express = express();


// Sync database and start server
const PORT = process.env.PORT || 3000;

sequelize.sync({ force: false }).then(() => {
  app.listen(PORT, () => {
    console.log(`Server running on port ${PORT}`);
  });
}).catch(err => {
  console.error('Error connecting to database:', err);
}); 