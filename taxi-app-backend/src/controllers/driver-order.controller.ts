import {
  Count,
  CountSchema,
  Filter,
  repository,
  Where,
} from '@loopback/repository';
import {
  del,
  get,
  getModelSchemaRef,
  getWhereSchemaFor,
  param,
  patch,
  post,
  requestBody,
} from '@loopback/rest';
import {
  Driver,
  Order,
} from '../models';
import {DriverRepository} from '../repositories';

export class DriverOrderController {
  constructor(
    @repository(DriverRepository) protected driverRepository: DriverRepository,
  ) { }

  @get('/drivers/{id}/orders', {
    responses: {
      '200': {
        description: 'Array of Driver has many Order',
        content: {
          'application/json': {
            schema: {type: 'array', items: getModelSchemaRef(Order)},
          },
        },
      },
    },
  })
  async find(
    @param.path.string('id') id: string,
    @param.query.object('filter') filter?: Filter<Order>,
  ): Promise<Order[]> {
    return this.driverRepository.driverOrders(id).find(filter);
  }

  @post('/drivers/{id}/orders', {
    responses: {
      '200': {
        description: 'Driver model instance',
        content: {'application/json': {schema: getModelSchemaRef(Order)}},
      },
    },
  })
  async create(
    @param.path.string('id') id: typeof Driver.prototype.email,
    @requestBody({
      content: {
        'application/json': {
          schema: getModelSchemaRef(Order, {
            title: 'NewOrderInDriver',
            exclude: ['ID'],
            optional: ['driver_email']
          }),
        },
      },
    }) order: Omit<Order, 'ID'>,
  ): Promise<Order> {
    return this.driverRepository.driverOrders(id).create(order);
  }

  @patch('/drivers/{id}/orders', {
    responses: {
      '200': {
        description: 'Driver.Order PATCH success count',
        content: {'application/json': {schema: CountSchema}},
      },
    },
  })
  async patch(
    @param.path.string('id') id: string,
    @requestBody({
      content: {
        'application/json': {
          schema: getModelSchemaRef(Order, {partial: true}),
        },
      },
    })
    order: Partial<Order>,
    @param.query.object('where', getWhereSchemaFor(Order)) where?: Where<Order>,
  ): Promise<Count> {
    return this.driverRepository.driverOrders(id).patch(order, where);
  }

  @del('/drivers/{id}/orders', {
    responses: {
      '200': {
        description: 'Driver.Order DELETE success count',
        content: {'application/json': {schema: CountSchema}},
      },
    },
  })
  async delete(
    @param.path.string('id') id: string,
    @param.query.object('where', getWhereSchemaFor(Order)) where?: Where<Order>,
  ): Promise<Count> {
    return this.driverRepository.driverOrders(id).delete(where);
  }
}
