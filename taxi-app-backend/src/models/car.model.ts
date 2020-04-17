import {Entity, model, property} from '@loopback/repository';

@model()
export class Car extends Entity {
  @property({
    type: 'string',
    required: true,
  })
  license_plate: string;

  @property({
    type: 'string',
    required: true,
  })
  brand: string;

  @property({
    type: 'string',
    required: true,
  })
  model: string;

  @property({
    type: 'string',
    required: true,
  })
  color: string;

  @property({
    type: 'string',
    id: true,
    required: true,
  })
  driver_email: string;


  constructor(data?: Partial<Car>) {
    super(data);
  }
}

export interface CarRelations {
  // describe navigational properties here
}

export type CarWithRelations = Car & CarRelations;
