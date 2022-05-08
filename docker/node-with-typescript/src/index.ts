import express, { Request, Response, NextFunction } from 'express';

const app = express();
const PORT = 3000;

app.get('/', (req: Request, res: Response) => {
  // res.send('Hello, World from TypeScript + Node.js!');
  res.json({
    message: 'TypeScript + Node.js application is running',
    status: 'success',
    timestamp: new Date().toISOString()
  });
});

app.use((req: Request, res: Response) => {
  res.status(404).json({
    error: 'Not Found',
    message: 'The requested resource was not found.',
    code: 404
  });
});

app.use((err: Error, req: Request, res: Response, next: NextFunction) => {
  console.error(err.stack);
  res.status(500).json({
    error: 'Internal Server Error',
    message: err.message,
    code: 500
  });
});

app.listen(PORT, () => {
  console.log(`Server is running at http://localhost:${PORT}`);
});
