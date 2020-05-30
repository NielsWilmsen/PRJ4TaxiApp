import {Count, CountSchema, Filter, FilterExcludingWhere, repository, Where} from '@loopback/repository';
import {del, get, getModelSchemaRef, param, patch, post, put, requestBody} from '@loopback/rest';
import {Customer, Driver, Order} from '../models';
import {CustomerRepository, DriverRepository, OrderRepository} from '../repositories';
import {secured, SecuredType} from '../auth';
import {DistanceUtils} from '../utils/DistanceUtils';
import {PushNotificationController} from './';
export class OrderController {
  constructor(
    @repository(OrderRepository)
    public orderRepository: OrderRepository,
    @repository(CustomerRepository)
    public customerRepository: CustomerRepository,
    @repository(DriverRepository)
    public driverRepository: DriverRepository,
    public pushController: PushNotificationController,
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
    const customerToUpdate: Customer = await this.customerRepository.findById(order.customer_email);
    customerToUpdate.status = 1;
    await this.customerRepository.updateById(order.customer_email, customerToUpdate);
    this.pushController.newOrderNotification();
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
      if(DistanceUtils.distanceFromOrder(value.pick_up_latitude, value.pick_up_longitude, driversLat, driversLon, range) &&
         value.status === 0){
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

  @secured(SecuredType.HAS_ROLES, ['driver'])
  @patch('/orders/acceptOrder/{id}/{driverEmail}', {
    responses: {
      '204': {
        description: 'Order PATCH success',
      },
    },
  })
  async acceptOrder(
      @param.path.number('id') id: number,
      @param.path.string('driverEmail') driverEmail: string,
  ): Promise<void> {
    const orderToUpdate: Order = await this.findById(id);
    const driverToUpdate: Driver = await this.driverRepository.findById(driverEmail);
    //0 = Order not assigned | 1 = Order awaits driver for pickup | 2 = Order is ongoing | 3 = Order is finalised | 4 = Order is cancelled
    orderToUpdate.status = 1;
    // eslint-disable-next-line @typescript-eslint/camelcase
    orderToUpdate.driver_email = driverEmail;
    driverToUpdate.status = 1;

    await this.driverRepository.updateById(driverEmail, driverToUpdate);
    await this.orderRepository.updateById(id, orderToUpdate);
  }

  @secured(SecuredType.HAS_ROLES, ['driver'])
  @patch('/orders/pickUpCustomer/{id}/{driverLat}/{driverLon}', {
    responses: {
      '204': {
        description: 'Order PATCH success',
      },
    },
  })
  async pickUpCustomer(
      @param.path.number('id') id: number,
      @param.path.number('driverLat') driverLat: number,
      @param.path.number('driverLon') driverLon: number,
  ): Promise<void> {
    const orderToUpdate:Order = await this.orderRepository.findById(id);

    if(DistanceUtils.distanceFromOrder(orderToUpdate.pick_up_latitude, orderToUpdate.pick_up_longitude, driverLat, driverLon, 1) && orderToUpdate.status === 1){
      //0 = Order not assigned | 1 = Order awaits driver for pickup | 2 = Order is ongoing | 3 = Order is finalised | 4 = Order is cancelled
      orderToUpdate.status = 2;
      await this.orderRepository.updateById(id, orderToUpdate);
    } else {
      throw new Error('The driver is too far in order to be able to pick up the customer')
    }
  }

  @secured(SecuredType.HAS_ROLES, ['driver'])
  @patch('/orders/finishOrder/{id}/{lat}/{lon}', {
    responses: {
      '204': {
        description: 'Order PATCH success',
      },
    },
  })
  async finishOrder(
      @param.path.number('id') id: number,
      @param.path.number('lat') lat: number,
      @param.path.number('lon') lon: number,
  ): Promise<void> {
    const orderToUpdate: Order = await this.orderRepository.findById(id);
    if (DistanceUtils.distanceFromOrder(orderToUpdate.drop_latitude, orderToUpdate.drop_longitude, lat, lon, 1) && orderToUpdate.status === 2) {
      // eslint-disable-next-line @typescript-eslint/camelcase
      if (orderToUpdate.driver_email != null) {
        const driverToUpdate: Driver = await this.driverRepository.findById(orderToUpdate.driver_email);
        const customerToUpdate: Customer = await this.customerRepository.findById(orderToUpdate.customer_email);

        driverToUpdate.status = 0;
        customerToUpdate.status = 0;
        //0 = Order not assigned | 1 = Order awaits driver for pickup | 2 = Order is ongoing | 3 = Order is finalised | 4 = Order is cancelled
        orderToUpdate.status = 3;

        await this.customerRepository.updateById(customerToUpdate.email, customerToUpdate);
        await this.driverRepository.updateById(driverToUpdate.email, driverToUpdate);
        await this.orderRepository.updateById(orderToUpdate.ID, orderToUpdate);
      }
    } else {
      throw new Error("You are too far away from the drop point in order to finish the order")
    }
  }

  @secured(SecuredType.IS_AUTHENTICATED)
  @patch('/orders/cancelOrder/{id}', {
    responses: {
      '204': {
        description: 'Order PATCH success',
      },
    },
  })
  async cancelOrder(
      @param.path.number('id') id: number,
  ): Promise<void> {
    const orderToUpdate: Order = await this.orderRepository.findById(id);
    if(orderToUpdate.driver_email == null) {
      const customerToUpdate: Customer = await this.customerRepository.findById(orderToUpdate.customer_email);

      //0 = Order not assigned | 1 = Order awaits driver for pickup | 2 = Order is ongoing | 3 = Order is finalised | 4 = Order is cancelled
      orderToUpdate.status = 4;
      customerToUpdate.status = 0;

      await this.customerRepository.updateById(orderToUpdate.customer_email, customerToUpdate);
      await this.orderRepository.updateById(id, orderToUpdate);
    } else {
      throw new Error("The order has already been accepted and it can't be cancelled anymore");
    }
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
