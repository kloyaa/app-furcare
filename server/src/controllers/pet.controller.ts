import { TRequest } from '../_core/interfaces/overrides.interface';
import { type Response } from 'express';
import Pet from '../schema/Pet.schema';
import { statuses } from '../_core/const/api.statuses';
import { validateCreatePet } from '../_core/validators/pet.validator';
import { emitter } from '../_core/events/activity.event';
import { ActivityType, EventName } from '../_core/enum/activity.enum';
import { IActivity } from '../_core/interfaces/activity.interface';
import { isObjectIdOrHexString } from 'mongoose';
import { handleMongooseError } from '../_core/utils/db/error.util';

/**
 * Creates a new pet for a user.
 *
 * @param {TRequest} req - The request object containing the pet's data.
 * @param {Response} res - The response object used to send the response.
 * @return {Promise<any>} A promise that resolves when the pet is created successfully or rejects with an error.
 */
export const createPet = async (req: TRequest, res: Response): Promise<any> => {
  const error = validateCreatePet(req.body);
  if (error) {
    return res.status(400).json({
      ...statuses['501'],
      message: error.details[0].message.replace(/['"]/g, ''),
    });
  }

  try {
    const pet = await Pet.findOne({
      name: { $regex: new RegExp(`^${req.body.name}$`, 'i') },
    });
    if (pet) {
      return res.status(400).json(statuses['0200']);
    }

    const createdPet = await Pet.create({
      ...req.body,
      user: req.user.id,
    });

    emitter.emit(EventName.ACTIVITY, {
      user: req.user.id as any,
      description: ActivityType.PET_ADDED,
    } as IActivity);

    return res.status(201).json(createdPet);
  } catch (error) {
    console.log('@createPet error', error);
    return handleMongooseError(error, res);
  }
};

/**
 * Updates an existing pet for a user.
 *
 * @param {TRequest} req - The request object containing the pet's updated data.
 * @param {Response} res - The response object used to send the response.
 * @return {Promise<any>} A promise that resolves when the pet is updated successfully or rejects with an error.
 */
export const updatePet = async (req: TRequest, res: Response): Promise<any> => {
  const { id } = req.params;
  if (!id || !isObjectIdOrHexString(id)) {
    return res.status(400).json(statuses['0901']);
  }

  const error = validateCreatePet(req.body);
  if (error) {
    return res.status(400).json({
      ...statuses['501'],
      message: error.details[0].message.replace(/['"]/g, ''),
    });
  }

  try {
    const updatedPet = await Pet.findByIdAndUpdate(id, req.body, { new: true });
    if (!updatedPet) {
      return res.status(404).json(statuses['02']);
    }

    emitter.emit(EventName.ACTIVITY, {
      user: req.user.id as any,
      description: ActivityType.PET_UPDATED,
    } as IActivity);

    return res.status(200).json(updatedPet);
  } catch (error) {
    console.log('@updatePet error', error);
    return handleMongooseError(error, res);
  }
};

/**
 * Retrieves all pets associated with the authenticated user.
 *
 * @param {TRequest} req - The request object containing the user's access token.
 * @param {Response} res - The response object used to send the list of pets.
 * @return {Promise<any>} A promise that resolves with a 200 status and the list of pets if successful,
 *                        or rejects with a 400 status in case of an error.
 */
export const getPets = async (req: TRequest, res: Response): Promise<any> => {
  try {
    const pets = await Pet.find({ user: req.user.id }).sort({ createdAt: -1 });
    return res.status(200).json(pets);
  } catch (error) {
    console.log('@getPets error', error);
    return handleMongooseError(error, res);
  }
};

/**
 * Deletes an existing pet for a user.
 *
 * @param {TRequest} req - The request object containing the pet's id as a parameter.
 * @param {Response} res - The response object used to send the response.
 * @return {Promise<any>} A promise that resolves with a 200 status when the pet is deleted successfully or rejects with a 400 status when there is an error.
 */
export const deletePet = async (req: TRequest, res: Response): Promise<any> => {
  const { id } = req.params;
  if (!id || !isObjectIdOrHexString(id)) {
    return res.status(400).json(statuses['0901']);
  }

  try {
    const deletedPet = await Pet.findByIdAndDelete(id);

    if (!deletedPet) {
      return res.status(404).json(statuses['02']);
    }

    emitter.emit(EventName.ACTIVITY, {
      user: req.user.id as any,
      description: ActivityType.PET_DELETED,
    } as IActivity);

    return res.status(200).json(statuses['00']);
  } catch (error) {
    console.log('@deletePet error', error);
    return handleMongooseError(error, res);
  }
};
