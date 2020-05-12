import {Count, CountSchema, Filter, FilterExcludingWhere, repository, Where} from '@loopback/repository';
import {del, get, getModelSchemaRef, param, patch, post, put, requestBody} from '@loopback/rest';
import {logInUtils} from '../utils';
import {Driver} from '../models';
import {DriverRepository} from '../repositories';
import {HttpErrors} from '@loopback/rest/dist';
import {promisify} from 'util';
import {Credentials, JWT_SECRET} from '../auth';

const {sign} = require('jsonwebtoken');
const signAsync = promisify(sign);

export class DriverController {
  constructor(
    @repository(DriverRepository)
    public driverRepository : DriverRepository,
  ) {}

  @post('/drivers/login')
  async login(@requestBody() credentials: Credentials) {
    if(!credentials.username || !credentials.password){
      throw new HttpErrors.BadRequest("Missing_Username_Or_Password");
    }
    const user = await this.driverRepository.findOne({
      where: {
        email: credentials.username
      }
    });

    if(!user){
      throw new HttpErrors.Unauthorized("Email_Not_Found");
    }
    const isPasswordMatched = logInUtils.encrypt(credentials.password, 5) == user.password;

    if(!isPasswordMatched){
      throw new  HttpErrors.Unauthorized("Invalid_Password");
    }

    const tokenObject = {username: credentials.username};
    const token = await signAsync(tokenObject, JWT_SECRET);
    //0 = user; 1 = driver
    const {email} = user;
    return {
      token,
      email,
      //0 = user; 1 = driver
      roles: 1,
    };
  }

  @post('/drivers', {
    responses: {
      '200': {
        description: 'Driver model instance',
        content: {'application/json': {schema: getModelSchemaRef(Driver)}},
      },
    },
  })
  async create(
    @requestBody({
      content: {
        'application/json': {
          schema: getModelSchemaRef(Driver, {
            title: 'NewDriver',
          }),
        },
      },
    })
    driver: Omit<Driver, 'email'>,
  ): Promise<Driver> {
    driver.password = logInUtils.encrypt(driver.password, 5);
    return this.driverRepository.create(driver);
  }

  @get('/drivers/count', {
    responses: {
      '200': {
        description: 'Driver model count',
        content: {'application/json': {schema: CountSchema}},
      },
    },
  })
  async count(
    @param.where(Driver) where?: Where<Driver>,
  ): Promise<Count> {
    return this.driverRepository.count(where);
  }

  @get('/drivers', {
    responses: {
      '200': {
        description: 'Array of Driver model instances',
        content: {
          'application/json': {
            schema: {
              type: 'array',
              items: getModelSchemaRef(Driver, {includeRelations: true}),
            },
          },
        },
      },
    },
  })
  async find(
    @param.filter(Driver) filter?: Filter<Driver>,
  ): Promise<Driver[]> {
    return this.driverRepository.find(filter);
  }

  @patch('/drivers', {
    responses: {
      '200': {
        description: 'Driver PATCH success count',
        content: {'application/json': {schema: CountSchema}},
      },
    },
  })
  async updateAll(
    @requestBody({
      content: {
        'application/json': {
          schema: getModelSchemaRef(Driver, {partial: true}),
        },
      },
    })
    driver: Driver,
    @param.where(Driver) where?: Where<Driver>,
  ): Promise<Count> {
    return this.driverRepository.updateAll(driver, where);
  }

  @get('/drivers/{id}', {
    responses: {
      '200': {
        description: 'Driver model instance',
        content: {
          'application/json': {
            schema: getModelSchemaRef(Driver, {includeRelations: true}),
          },
        },
      },
    },
  })
  async findById(
    @param.path.string('id') id: string,
    @param.filter(Driver, {exclude: 'where'}) filter?: FilterExcludingWhere<Driver>
  ): Promise<Driver> {
    return this.driverRepository.findById(id, filter);
  }

  @patch('/drivers/{id}', {
    responses: {
      '204': {
        description: 'Driver PATCH success',
      },
    },
  })
  async updateById(
    @param.path.string('id') id: string,
    @requestBody({
      content: {
        'application/json': {
          schema: getModelSchemaRef(Driver, {partial: true}),
        },
      },
    })
    driver: Driver,
  ): Promise<void> {
    await this.driverRepository.updateById(id, driver);
  }

  @put('/drivers/{id}', {
    responses: {
      '204': {
        description: 'Driver PUT success',
      },
    },
  })
  async replaceById(
    @param.path.string('id') id: string,
    @requestBody() driver: Driver,
  ): Promise<void> {
    await this.driverRepository.replaceById(id, driver);
  }

  @del('/drivers/{id}', {
    responses: {
      '204': {
        description: 'Driver DELETE success',
      },
    },
  })
  async deleteById(@param.path.string('id') id: string): Promise<void> {
    await this.driverRepository.deleteById(id);
  }
}
