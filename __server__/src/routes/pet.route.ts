import { Router } from 'express';
import { createPet, deletePet, updatePet, getPets } from '../controllers/pet.controller';
import { isAuthenticated } from '../_core/middlewares/jwt.middleware';
const router = Router();

const commonMiddlewares = [isAuthenticated];

router.post('/pet/v1', commonMiddlewares, createPet as any);
router.get('/pet/v1', commonMiddlewares, getPets as any);
router.put('/pet/v1/:id', commonMiddlewares, updatePet as any);
router.delete('/pet/v1/:id', commonMiddlewares, deletePet as any);

export default router;