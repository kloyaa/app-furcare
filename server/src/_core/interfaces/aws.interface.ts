export interface AWSConfig {
  region: string;
  accessKeyId?: string;
  secretAccessKey?: string;
  sessionToken?: string;
}

export interface S3UploadOptions {
  bucket: string;
  key: string;
  body: Buffer | string;
  contentType?: string;
  acl?: 'private' | 'public-read' | 'public-read-write';
  metadata?: Record<string, string>;
}

export interface S3DownloadOptions {
  bucket: string;
  key: string;
}

export interface S3DeleteOptions {
  bucket: string;
  key: string;
}

export interface S3ListOptions {
  bucket: string;
  prefix?: string;
  maxKeys?: number;
  continuationToken?: string;
}

export interface SecretsManagerOptions {
  secretName: string;
  secretValue?: string | Record<string, any>;
  description?: string;
  kmsKeyId?: string;
}

export interface SecretsManagerListOptions {
  maxResults?: number;
  nextToken?: string;
  filters?: Array<{
    key:
      | 'description'
      | 'name'
      | 'tag-key'
      | 'tag-value'
      | 'primary-region'
      | 'owning-service'
      | 'all';
    values: string[];
  }>;
}
