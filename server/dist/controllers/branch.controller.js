"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.clearBranches = exports.getBranches = exports.createRandomBranches = void 0;
const faker_1 = require("@faker-js/faker");
const branch_schema_1 = require("../schema/branch.schema");
const api_statuses_1 = require("../_core/const/api.statuses");
const error_util_1 = require("../_core/utils/db/error.util");
const utils_1 = require("../_core/utils/utils");
const createRandomBranches = async (req, res) => {
    try {
        const generatedBranches = await branch_schema_1.Branch.find().sort({ createdAt: -1 });
        if (generatedBranches.length > 0) {
            return res.status(400).json(api_statuses_1.statuses['03']);
        }
        const branches = [
            {
                name: 'Uptown Branch',
                address: `Brgy. ${faker_1.faker.location.street()} St., Cagayan de Oro City, Philippines`,
                phone: `09${(0, utils_1.generateRandomNumber)(9)}`,
                open: true,
            },
            {
                name: 'Downtown Branch',
                address: `Brgy. ${faker_1.faker.location.street()} St., Cagayan de Oro City, Philippines`,
                phone: `09${(0, utils_1.generateRandomNumber)(9)}`,
                open: faker_1.faker.datatype.boolean(),
            },
            {
                name: 'Carmen Branch',
                address: `Brgy. ${faker_1.faker.location.street()} St., Cagayan de Oro City, Philippines`,
                phone: `09${(0, utils_1.generateRandomNumber)(9)}`,
                open: faker_1.faker.datatype.boolean(),
            },
            {
                name: 'Brgy. 31 Branch',
                address: `Brgy. ${faker_1.faker.location.street()} St., Cagayan de Oro City, Philippines`,
                phone: `09${(0, utils_1.generateRandomNumber)(9)}`,
                open: faker_1.faker.datatype.boolean(),
            },
            {
                name: 'Brgy. 12 Branch',
                address: `Brgy. ${faker_1.faker.location.street()} St., Cagayan de Oro City, Philippines`,
                phone: `09${(0, utils_1.generateRandomNumber)(9)}`,
                open: faker_1.faker.datatype.boolean(),
            },
            {
                name: 'Lapasan Branch',
                address: `Brgy. ${faker_1.faker.location.street()} St., Cagayan de Oro City, Philippines`,
                phone: `09${(0, utils_1.generateRandomNumber)(9)}`,
                open: faker_1.faker.datatype.boolean(),
            },
        ];
        await branch_schema_1.Branch.insertMany(branches);
        return res.status(201).json(api_statuses_1.statuses['00']);
    }
    catch (error) {
        console.log('@createRandomBranches error', error);
        return (0, error_util_1.handleMongooseError)(error, res);
    }
};
exports.createRandomBranches = createRandomBranches;
const getBranches = async (req, res) => {
    try {
        const branches = await branch_schema_1.Branch.find().sort({ createdAt: -1 });
        return res.status(200).json(branches);
    }
    catch (error) {
        console.log('@getBranches error', error);
        return (0, error_util_1.handleMongooseError)(error, res);
    }
};
exports.getBranches = getBranches;
const clearBranches = async (req, res) => {
    try {
        await branch_schema_1.Branch.deleteMany({});
        return res.status(200).json(api_statuses_1.statuses['00']);
    }
    catch (error) {
        console.log('@clearBranches error', error);
        return (0, error_util_1.handleMongooseError)(error, res);
    }
};
exports.clearBranches = clearBranches;
