import { AWSConfig } from "../../interfaces/aws.interface";
import { AWSService } from "./AWSService";

export class AWSServiceSingleton {
    private static instance: AWSService;

    static getInstance(config?: AWSConfig): AWSService {
        if (!AWSServiceSingleton.instance) {
            if (!config) {
                throw new Error('AWS config required for first initialization');
            }
            AWSServiceSingleton.instance = new AWSService(config);
        }
        return AWSServiceSingleton.instance;
    }
}