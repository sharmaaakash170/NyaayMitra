import { Request, Response, NextFunction } from 'express';
import { validationResult, ValidationChain } from 'express-validator';
import { ErrorResponse } from '../utils/errorResponse';

/**
 * Middleware to validate request data
 */
export const validate = (validations: ValidationChain[]) => {
  return async (req: Request, res: Response, next: NextFunction) => {
    await Promise.all(validations.map(validation => validation.run(req)));

    const errors = validationResult(req);

    if (errors.isEmpty()) {
      return next();
    }

    const extractedErrors: string[] = [];

    errors.array().forEach(err => {
      if ('param' in err && typeof err.param === 'string') {
        extractedErrors.push(`${err.param}: ${err.msg}`);
      } else {
        extractedErrors.push(err.msg);
      }
    });

    return next(new ErrorResponse(extractedErrors.join(', '), 400));
  };
};
