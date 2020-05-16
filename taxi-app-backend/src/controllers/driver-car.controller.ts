import {Count, CountSchema, Filter, repository, Where} from '@loopback/repository';
import {del, get, getModelSchemaRef, getWhereSchemaFor, param, patch, post, requestBody} from '@loopback/rest';
import {Car, Driver} from '../models';
import {DriverRepository} from '../repositories';
import {secured, SecuredType} from '../auth';

export class DriverCarController {
  constructor(
    @repository(DriverRepository) protected driverRepository: DriverRepository,
  ) {
  }

  @secured(SecuredType.HAS_ROLES, ['driver'])
  @get('/drivers/{id}/car', {
    responses: {
      '200': {
        description: 'Driver has one Car',
        content: {
          'application/json': {
            schema: getModelSchemaRef(Car),
          },
        },
      },
    },
  })
  async get(
    @param.path.string('id') id: string,
    @param.query.object('filter') filter?: Filter<Car>,
  ): Promise<Car> {
    return this.driverRepository.cars(id).get(filter);
  }

  @secured(SecuredType.HAS_ROLES, ['driver'])
  @post('/drivers/{id}/car', {
    responses: {
      '200': {
        description: 'Driver model instance',
        content: {'application/json': {schema: getModelSchemaRef(Car)}},
      },
    },
  })
  async create(
    @param.path.string('id') id: typeof Driver.prototype.email,
    @requestBody({
      content: {
        'application/json': {
          schema: getModelSchemaRef(Car, {
            title: 'NewCarInDriver',
            exclude: ['driver_email'],
            optional: ['driver_email']
          }),
        },
      },
    }) car: Omit<Car, 'driver_email'>,
  ): Promise<Car> {
    return this.driverRepository.cars(id).create(car);
  }

  @secured(SecuredType.HAS_ROLES, ['driver'])
  @patch('/drivers/{id}/car', {
    responses: {
      '200': {
        description: 'Driver.Car PATCH success count',
        content: {'application/json': {schema: CountSchema}},
      },
    },
  })
  async patch(
    @param.path.string('id') id: string,
    @requestBody({
      content: {
        'application/json': {
          schema: getModelSchemaRef(Car, {partial: true}),
        },
      },
    })
      car: Partial<Car>,
    @param.query.object('where', getWhereSchemaFor(Car)) where?: Where<Car>,
  ): Promise<Count> {
    return this.driverRepository.cars(id).patch(car, where);
  }

  @secured(SecuredType.DENY_ALL)
  @del('/drivers/{id}/car', {
    responses: {
      '200': {
        description: 'Driver.Car DELETE success count',
        content: {'application/json': {schema: CountSchema}},
      },
    },
  })
  async delete(
    @param.path.string('id') id: string,
    @param.query.object('where', getWhereSchemaFor(Car)) where?: Where<Car>,
  ): Promise<Count> {
    return this.driverRepository.cars(id).delete(where);
  }
}
