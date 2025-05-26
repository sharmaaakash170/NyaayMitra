import { Request, Response, NextFunction } from 'express';
import bcrypt from 'bcryptjs';
import jwt from 'jsonwebtoken';
import { asyncHandler } from '../utils/asyncHandler';
import { ErrorResponse } from '../utils/errorResponse';
import prisma from '../config/prisma';
import type { Role } from '@prisma/client';

/**
 * Register a new user
 * @route POST /api/auth/register
 * @access Public
 */
export const register = asyncHandler(
  async (req: Request, res: Response, next: NextFunction) => {
    const { email, password, firstName, lastName, phone, role } = req.body;

    // Check if user already exists
    const userExists = await prisma.user.findUnique({
      where: { email },
    });

    if (userExists) {
      return next(new ErrorResponse('User already exists', 400));
    }

    // Hash password
    const salt = await bcrypt.genSalt(10);
    const hashedPassword = await bcrypt.hash(password, salt);

    // Validate role
    const userRole = role ? role : 'USER';
    if (userRole !== 'USER' && userRole !== 'MASTER') {
      return next(new ErrorResponse('Invalid role', 400));
    }

    // Create user
    const user = await prisma.user.create({
      data: {
        email,
        password: hashedPassword,
        firstName,
        lastName,
        phone,
        role: userRole as Role,
      },
    });

    // Create token
    const token = await generateToken(user.id);

    res.status(201).json({
      success: true,
      token,
      user: {
        id: user.id,
        email: user.email,
        firstName: user.firstName,
        lastName: user.lastName,
        role: user.role,
      },
    });
  }
);

/**
 * Login user
 * @route POST /api/auth/login
 * @access Public
 */
export const login = asyncHandler(
  async (req: Request, res: Response, next: NextFunction) => {
    const { email, password } = req.body;

    // Check if user exists
    const user = await prisma.user.findUnique({
      where: { email },
    });

    if (!user) {
      return next(new ErrorResponse('Invalid credentials', 401));
    }

    // Check if password matches
    const isMatch = await bcrypt.compare(password, user.password);

    if (!isMatch) {
      return next(new ErrorResponse('Invalid credentials', 401));
    }

    // Generate token
    const token = await generateToken(user.id);

    res.status(200).json({
      success: true,
      token,
      user: {
        id: user.id,
        email: user.email,
        firstName: user.firstName,
        lastName: user.lastName,
        role: user.role,
      },
    });
  }
);

/**
 * Get current logged in user
 * @route GET /api/auth/me
 * @access Private
 */
export const getMe = asyncHandler(
  async (req: Request, res: Response, next: NextFunction) => {
    // User is already set in req by the protect middleware
    const user = await prisma.user.findUnique({
      where: { id: req.user.id },
      select: {
        id: true,
        email: true,
        firstName: true,
        lastName: true,
        phone: true,
        role: true,
        createdAt: true,
        updatedAt: true,
      },
    });

    if (!user) {
      return next(new ErrorResponse('User not found', 404));
    }

    res.status(200).json({
      success: true,
      data: user,
    });
  }
);

/**
 * Generate JWT token with a fixed expiration time of 1 hour
 */
const generateToken = (id: string): Promise<string> => {
  return new Promise((resolve, reject) => {
    const jwtSecret = process.env.JWT_SECRET!;
    if (!jwtSecret) {
      reject(new Error('JWT_SECRET is not defined'));
      return;
    }

    jwt.sign(
      { id },
      jwtSecret,
      { expiresIn: '1h' },
      (err, token) => {
        if (err) {
          reject(err);
          return;
        }
        if (token) {
          resolve(token);
        } else {
          reject(new Error('Token is null'));
        }
      }
    );
  });
};