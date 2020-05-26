import {Entity, model, property} from '@loopback/repository';

@model()
export class Order extends Entity {
  @property({
    type: 'string',
    required: true,
  })
  customer_email: string;

  @property({
    type: 'string',
  })
  driver_email?: string;

  @property({
    type: 'number',
    required: true,
  })
  fare: number;

  @property({
    type: 'string',
    required: true,
  })
  pick_up_point: string;

  @property({
    type: 'string',
    required: true,
  })
  destination: string;

  @property({
    type: 'number',
    id: true,
    generated: true,
  })
  ID?: number;

  @property({
    type: 'number',
    required: true,
  })
  pick_up_latitude: number;

  @property({
    type: 'number',
    required: true,
  })
  pick_up_longitude: number;

  @property({
    type: 'number',
    required: true,
  })
  drop_latitude: number;

  @property({
    type: 'number',
    required: true,
  })
  drop_longitude: number;

  @property({
    type: 'number',
    required: true,
  })
  status: number;


  constructor(data?: Partial<Order>) {
    super(data);
  }
}

export interface OrderRelations {
  // describe navigational properties here
}

export type OrderWithRelations = Order & OrderRelations;
