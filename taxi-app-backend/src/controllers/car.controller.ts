import {Count, CountSchema, Filter, FilterExcludingWhere, repository, Where} from '@loopback/repository';
import {del, get, getModelSchemaRef, param, patch, post, put, requestBody} from '@loopback/rest';
import {Car} from '../models';
import {CarRepository} from '../repositories';
import {secured, SecuredType} from '../auth';

export class CarController {
  constructor(
    @repository(CarRepository)
    public carRepository : CarRepository,
  ) {}

  @secured(SecuredType.HAS_ROLES, ['driver'])
  @post('/cars', {
    responses: {
      '200': {
        description: 'Car model instance',
        content: {'application/json': {schema: getModelSchemaRef(Car)}},
      },
    },
  })
  async create(
    @requestBody({
      content: {
        'application/json': {
          schema: getModelSchemaRef(Car, {
            title: 'NewCar',
          }),
        },
      },
    })
      car: Omit<Car, 'driver_email'>,
  ): Promise<Car> {
    return this.carRepository.create(car);
  }

  @secured(SecuredType.IS_AUTHENTICATED)
  @get('/cars/count', {
    responses: {
      '200': {
        description: 'Car model count',
        content: {'application/json': {schema: CountSchema}},
      },
    },
  })
  async count(
    @param.query.string ('access_token') access_token : string,
    @param.where(Car) where?: Where<Car>,
  ): Promise<Count> {
    console.log(access_token);
    return this.carRepository.count(where);
  }

  @secured(SecuredType.DENY_ALL)
  @get('/cars', {
    responses: {
      '200': {
        description: 'Array of Car model instances',
        content: {
          'application/json': {
            schema: {
              type: 'array',
              items: getModelSchemaRef(Car, {includeRelations: true}),
            },
          },
        },
      },
    },
  })
  async find(
    @param.filter(Car) filter?: Filter<Car>,
  ): Promise<Car[]> {
    return this.carRepository.find(filter);
  }

  @secured(SecuredType.DENY_ALL)
  @patch('/cars', {
    responses: {
      '200': {
        description: 'Car PATCH success count',
        content: {'application/json': {schema: CountSchema}},
      },
    },
  })
  async updateAll(
    @requestBody({
      content: {
        'application/json': {
          schema: getModelSchemaRef(Car, {partial: true}),
        },
      },
    })
      car: Car,
    @param.where(Car) where?: Where<Car>,
  ): Promise<Count> {
    return this.carRepository.updateAll(car, where);
  }

  @secured(SecuredType.IS_AUTHENTICATED)
  @get('/cars/{id}', {
    responses: {
      '200': {
        description: 'Car model instance',
        content: {
          'application/json': {
            schema: getModelSchemaRef(Car, {includeRelations: true}),
          },
        },
      },
    },
  })
  async findById(
    @param.path.string('id') id: string,
    @param.filter(Car, {exclude: 'where'}) filter?: FilterExcludingWhere<Car>
  ): Promise<Car> {
    return this.carRepository.findById(id, filter);
  }

  @secured(SecuredType.HAS_ROLES, ['driver'])
  @patch('/cars/{id}', {
    responses: {
      '204': {
        description: 'Car PATCH success',
      },
    },
  })
  async updateById(
    @param.path.string('id') id: string,
    @requestBody({
      content: {
        'application/json': {
          schema: getModelSchemaRef(Car, {partial: true}),
        },
      },
    })
      car: Car,
  ): Promise<void> {
    await this.carRepository.updateById(id, car);
  }

  @secured(SecuredType.HAS_ROLES, ['driver'])
  @put('/cars/{id}', {
    responses: {
      '204': {
        description: 'Car PUT success',
      },
    },
  })
  async replaceById(
    @param.path.string('id') id: string,
    @requestBody() car: Car,
  ): Promise<void> {
    await this.carRepository.replaceById(id, car);
  }

  @secured(SecuredType.HAS_ROLES, ['driver'])
  @del('/cars/{id}', {
    responses: {
      '204': {
        description: 'Car DELETE success',
      },
    },
  })
  async deleteById(@param.path.string('id') id: string): Promise<void> {
    await this.carRepository.deleteById(id);
  }
}
