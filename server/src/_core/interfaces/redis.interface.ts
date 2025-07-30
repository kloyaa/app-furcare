export interface ISetPayload<T> {
  key: string;
  value: T;
}

export interface ISetResponse<T> {
  success: boolean;
  message: string;
  data?: T;
}

export interface IGetPayload {
  key: string;
}

export interface IGetResponse<T> {
  success: boolean;
  message: string;
  data?: T;
}
