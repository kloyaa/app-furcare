"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
const express_1 = require("express");
const pet_services_controller_1 = require("../controllers/pet_services.controller");
const jwt_middleware_1 = require("../_core/middlewares/jwt.middleware");
const router = (0, express_1.Router)();
const commonMiddlewares = [jwt_middleware_1.isAuthenticated];
router.get('/pet-services/v1', commonMiddlewares, pet_services_controller_1.getPetServices);
// Grooming
router.get('/pet-services/v1/grooming-options', commonMiddlewares, pet_services_controller_1.getGroomingExtra);
router.get('/pet-services/v1/grooming-schedules', commonMiddlewares, pet_services_controller_1.getGroomingSchedules);
router.get('/pet-services/v1/grooming-preferences', commonMiddlewares, pet_services_controller_1.getGroomingPreferences);
// Cages
router.get('/pet-services/v1/cages', commonMiddlewares, pet_services_controller_1.getAllCages);
router.post('/pet-services/v1/cages', commonMiddlewares, pet_services_controller_1.insertCages);
router.put('/pet-services/v1/cages', commonMiddlewares, pet_services_controller_1.updateCageOccupant);
router.get('/pet-services/v1/cages/availability/:id', commonMiddlewares, pet_services_controller_1.validateCageAvailability);
exports.default = router;
