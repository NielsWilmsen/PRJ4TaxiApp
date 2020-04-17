import {DefaultCrudRepository, repository, HasManyRepositoryFactory} from '@loopback/repository';
import {Customer, CustomerRelations, Order} from '../models';
import {DbDataSource} from '../datasources';
import {inject, Getter} from '@loopback/core';
import {OrderRepository} from './order.repository';

export class CustomerRepository extends DefaultCrudRepository<
  Customer,
  typeof Customer.prototype.email,
  CustomerRelations
> {

  public readonly customerOrders: HasManyRepositoryFactory<Order, typeof Customer.prototype.email>;

  constructor(
    @inject('datasources.db') dataSource: DbDataSource, @repository.getter('OrderRepository') protected orderRepositoryGetter: Getter<OrderRepository>,
  ) {
    super(Customer, dataSource);
    this.customerOrders = this.createHasManyRepositoryFactoryFor('customerOrders', orderRepositoryGetter,);
    this.registerInclusionResolver('customerOrders', this.customerOrders.inclusionResolver);
  }
}
