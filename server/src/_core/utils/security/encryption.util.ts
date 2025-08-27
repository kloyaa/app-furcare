import crypto from 'crypto';

export const encrypt = (json: any, secretKey: string) => {
  try {
    const text = JSON.stringify(json);
    const algorithm = 'AES-256-CBC';
    const key: any = crypto.scryptSync(secretKey, 'salt', 32);
    const iv: any = crypto.randomBytes(16);
    const cipher: any = crypto.createCipheriv(algorithm, key, iv);
    let encrypted = cipher.update(text, 'utf8', 'hex');
    encrypted += cipher.final('hex');

    return `${iv.toString('hex')}.${encrypted}`;
  } catch (error) {
    console.log('@encrypt error', error);
    return null;
  }
};

export const decrypt = (encryptedData: string, secretKey: string) => {
  try {
    const [hashIv, hashData] = encryptedData.split('.');
    const algorithm: any = 'AES-256-CBC';
    const key: any = crypto.scryptSync(secretKey, 'salt', 32);
    const iv: any = Buffer.from(hashIv, 'hex');
    const decipher = crypto.createDecipheriv(algorithm, key, iv);
    let decrypted = decipher.update(hashData, 'hex', 'utf8');
    decrypted += decipher.final('utf8');
    return JSON.parse(decrypted);
  } catch (error) {
    console.log('@decrypt error', error);
    return null;
  }
};
