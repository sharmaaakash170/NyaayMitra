import express from 'express';
import { protect } from '../middlewares/auth';

const router = express.Router();

// Placeholder for review routes
router.get('/', protect, (req, res) => {
  res.status(200).json({
    success: true,
    message: 'Review routes not implemented yet',
  });
});

export default router;