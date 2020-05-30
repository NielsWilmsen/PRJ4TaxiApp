import {Entity, model, property, hasMany} from '@loopback/repository';
import {Order} from './order.model';
@model()
export class Customer extends Entity {
  @property({
    type: 'string',
    required: true,
  })
  first_name: string;

  @property({
    type: 'string',
    required: true,
  })
  last_name: string;

  @property({
    type: 'string',
    id: true,
    required: true,
  })
  email: string;

  @property({
    type: 'string',
    required: true,
  })
  password: string;

  @property({
    type: 'string',
  })
  profile_picture_path: string;

  @property({
    type: 'number',
    required: true,
  })
  status: number;

  @property({
    type: 'string',
    required: true,
  })
  dToken: string;

  @hasMany(() => Order, {keyTo: 'customer_email'})
  customerOrders: Order[];

  constructor(data?: Partial<Customer>) {
    super(data);
  }
}

export interface CustomerRelations {
  // describe navigational properties here
}

export type CustomerWithRelations = Customer & CustomerRelations;
