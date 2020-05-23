import {Count, CountSchema, Filter, FilterExcludingWhere, repository, Where} from '@loopback/repository';
import {del, get, getModelSchemaRef, param, patch, post, put, requestBody} from '@loopback/rest';
import {Order} from '../models';
import {OrderRepository} from '../repositories';
import {secured, SecuredType} from '../auth';
import {DistanceUtils} from "../utils/DistanceUtils";

export class OrderController {
  constructor(
    @repository(OrderRepository)
    public orderRepository: OrderRepository,
  ) {
  }

  @secured(SecuredType.HAS_ROLES, ['customer'])
  @post('/orders', {
    responses: {
      '200': {
        description: 'Order model instance',
        content: {'application/json': {schema: getModelSchemaRef(Order)}},
      },
    },
  })
  async create(
    @requestBody({
      content: {
        'application/json': {
          schema: getModelSchemaRef(Order, {
            title: 'NewOrder',
            exclude: ['ID'],
          }),
        },
      },
    })
      order: Omit<Order, 'ID'>,
  ): Promise<Order> {
    return this.orderRepository.create(order);
  }

  @secured(SecuredType.IS_AUTHENTICATED)
  @get('/orders/count', {
    responses: {
      '200': {
        description: 'Order model count',
        content: {'application/json': {schema: CountSchema}},
      },
    },
  })
  async count(
    @param.where(Order) where?: Where<Order>,
  ): Promise<Count> {
    return this.orderRepository.count(where);
  }

  @secured(SecuredType.PERMIT_ALL)
  @get('/ordersInRange/{range}/{driversLon}/{driversLat}', {
    responses: {
      '200': {
        description: 'Array of Order model instances',
        content: {
          'application/json': {
            schema: {
              type: 'array',
              items: getModelSchemaRef(Order, {includeRelations: true}),
            },
          },
        },
      },
    },
  })
  async find(
    @param.path.number('range') range: number,
    @param.path.number('driversLon') driversLon: number,
    @param.path.number('driversLat') driversLat: number,
    @param.filter(Order) filter?: Filter<Order>,
  ): Promise<Order[]> {
    const orders: Array<Order> = await this.orderRepository.find(filter);
    const fittingOrders : Array<Order> = [];
    orders.forEach(function (value) {
      if(DistanceUtils.distanceFromOrder(value.latitude, value.longitude, driversLat, driversLon, range)){
        fittingOrders.push(value);
      }
    })
    return fittingOrders;
  }

  @secured(SecuredType.DENY_ALL)
  @patch('/orders', {
    responses: {
      '200': {
        description: 'Order PATCH success count',
        content: {'application/json': {schema: CountSchema}},
      },
    },
  })
  async updateAll(
    @requestBody({
      content: {
        'application/json': {
          schema: getModelSchemaRef(Order, {partial: true}),
        },
      },
    })
      order: Order,
    @param.where(Order) where?: Where<Order>,
  ): Promise<Count> {
    return this.orderRepository.updateAll(order, where);
  }

  @secured(SecuredType.IS_AUTHENTICATED)
  @get('/orders/{id}', {
    responses: {
      '200': {
        description: 'Order model instance',
        content: {
          'application/json': {
            schema: getModelSchemaRef(Order, {includeRelations: true}),
          },
        },
      },
    },
  })
  async findById(
    @param.path.number('id') id: number,
    @param.filter(Order, {exclude: 'where'}) filter?: FilterExcludingWhere<Order>
  ): Promise<Order> {
    return this.orderRepository.findById(id, filter);
  }

  @secured(SecuredType.IS_AUTHENTICATED)
  @patch('/orders/{id}', {
    responses: {
      '204': {
        description: 'Order PATCH success',
      },
    },
  })
  async updateById(
    @param.path.number('id') id: number,
    @requestBody({
      content: {
        'application/json': {
          schema: getModelSchemaRef(Order, {partial: true}),
        },
      },
    })
      order: Order,
  ): Promise<void> {
    await this.orderRepository.updateById(id, order);
  }

  @secured(SecuredType.DENY_ALL)
  @put('/orders/{id}', {
    responses: {
      '204': {
        description: 'Order PUT success',
      },
    },
  })
  async replaceById(
    @param.path.number('id') id: number,
    @requestBody() order: Order,
  ): Promise<void> {
    await this.orderRepository.replaceById(id, order);
  }

  @secured(SecuredType.DENY_ALL)
  @del('/orders/{id}', {
    responses: {
      '204': {
        description: 'Order DELETE success',
      },
    },
  })
  async deleteById(@param.path.number('id') id: number): Promise<void> {
    await this.orderRepository.deleteById(id);
  }
}
