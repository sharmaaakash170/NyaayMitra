import express from 'express';
import { protect, authorize } from '../middlewares/auth';

const router = express.Router();

// Placeholder for user routes
router.get('/', protect, authorize('ADMIN'), (req, res) => {
  res.status(200).json({
    success: true,
    message: 'User routes not implemented yet',
  });
});

export default router;