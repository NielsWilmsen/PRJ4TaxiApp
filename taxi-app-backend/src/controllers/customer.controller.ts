import {Count, CountSchema, Filter, FilterExcludingWhere, repository, Where} from '@loopback/repository';
import {del, get, getModelSchemaRef, param, patch, post, put, requestBody} from '@loopback/rest';
import {logInUtils} from '../utils';
import {Customer} from '../models';
import {CustomerRepository} from '../repositories';
import {Credentials, JWT_SECRET, secured, SecuredType} from '../auth';
import {HttpErrors} from '@loopback/rest/dist';
import {promisify} from 'util';

const {sign} = require('jsonwebtoken');
const signAsync = promisify(sign);

export class CustomerController {
  constructor(
    @repository(CustomerRepository)
    public customerRepository : CustomerRepository,
  ) {}

  @secured(SecuredType.PERMIT_ALL)
  @post('/customers/login')
  async login(@requestBody() credentials: Credentials) {
    if(!credentials.username || !credentials.password){
      throw new HttpErrors.BadRequest("Missing_Username_Or_Password");
    }
    const user = await this.customerRepository.findOne({
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
      //0 = customer; 1 = driver
      roles: 0,
    };
  }

  @secured(SecuredType.PERMIT_ALL)
  @post('/customers', {
    responses: {
      '200': {
        description: 'Customer model instance',
        content: {'application/json': {schema: getModelSchemaRef(Customer)}},
      },
    },
  })
  async create(
    @requestBody({
      content: {
        'application/json': {
          schema: getModelSchemaRef(Customer, {
            title: 'NewCustomer',
          }),
        },
      },
    })
      customer: Omit<Customer, 'email'>,
  ): Promise<Customer> {
    customer.password = logInUtils.encrypt(customer.password, 5);
    return this.customerRepository.create(customer);
  }

  @secured(SecuredType.IS_AUTHENTICATED)
  @get('/customers/count', {
    responses: {
      '200': {
        description: 'Customer model count',
        content: {'application/json': {schema: CountSchema}},
      },
    },
  })
  async count(
    @param.where(Customer) where?: Where<Customer>,
  ): Promise<Count> {
    return this.customerRepository.count(where);
  }

  @secured(SecuredType.IS_AUTHENTICATED)
  @get('/customers', {
    responses: {
      '200': {
        description: 'Array of Customer model instances',
        content: {
          'application/json': {
            schema: {
              type: 'array',
              items: getModelSchemaRef(Customer, {includeRelations: true}),
            },
          },
        },
      },
    },
  })
  async find(
    @param.filter(Customer) filter?: Filter<Customer>,
  ): Promise<Customer[]> {
    return this.customerRepository.find(filter);
  }

  @secured(SecuredType.DENY_ALL)
  @patch('/customers', {
    responses: {
      '200': {
        description: 'Customer PATCH success count',
        content: {'application/json': {schema: CountSchema}},
      },
    },
  })
  async updateAll(
    @requestBody({
      content: {
        'application/json': {
          schema: getModelSchemaRef(Customer, {partial: true}),
        },
      },
    })
      customer: Customer,
    @param.where(Customer) where?: Where<Customer>,
  ): Promise<Count> {
    return this.customerRepository.updateAll(customer, where);
  }

  @secured(SecuredType.IS_AUTHENTICATED)
  @get('/customers/{id}', {
    responses: {
      '200': {
        description: 'Customer model instance',
        content: {
          'application/json': {
            schema: getModelSchemaRef(Customer, {includeRelations: true}),
          },
        },
      },
    },
  })
  async findById(
    @param.path.string('id') id: string,
    @param.filter(Customer, {exclude: 'where'}) filter?: FilterExcludingWhere<Customer>
  ): Promise<Customer> {
    return this.customerRepository.findById(id, filter);
  }

  @secured(SecuredType.HAS_ROLES, ['customer'])
  @patch('/customers/{id}', {
    responses: {
      '204': {
        description: 'Customer PATCH success',
      },
    },
  })
  async updateById(
    @param.path.string('id') id: string,
    @requestBody({
      content: {
        'application/json': {
          schema: getModelSchemaRef(Customer, {partial: true}),
        },
      },
    })
      customer: Customer,
  ): Promise<void> {
    await this.customerRepository.updateById(id, customer);
  }

  @secured(SecuredType.DENY_ALL)
  @put('/customers/{id}', {
    responses: {
      '204': {
        description: 'Customer PUT success',
      },
    },
  })
  async replaceById(
    @param.path.string('id') id: string,
    @requestBody() customer: Customer,
  ): Promise<void> {
    await this.customerRepository.replaceById(id, customer);
  }

  @secured(SecuredType.DENY_ALL)
  @del('/customers/{id}', {
    responses: {
      '204': {
        description: 'Customer DELETE success',
      },
    },
  })
  async deleteById(@param.path.string('id') id: string): Promise<void> {
    await this.customerRepository.deleteById(id);
  }

  @secured(SecuredType.HAS_ROLES, ['customer'])
  @patch('/customers/{id}')
  async replacePicture(
    @param.path.string('id') id: string,
    @requestBody() picturePath: string,
  ): Promise<void> {
    let userToUpdate: Customer;
    userToUpdate = await this.customerRepository.findById(id);
    userToUpdate.profile_picture_path = picturePath;
    await this.customerRepository.updateById(id, userToUpdate);
  }
}

