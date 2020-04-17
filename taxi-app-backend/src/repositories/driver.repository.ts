import {DefaultCrudRepository, repository, HasManyRepositoryFactory, HasOneRepositoryFactory} from '@loopback/repository';
import {Driver, DriverRelations, Order, Car} from '../models';
import {DbDataSource} from '../datasources';
import {inject, Getter} from '@loopback/core';
import {OrderRepository} from './order.repository';
import {CarRepository} from './car.repository';

export class DriverRepository extends DefaultCrudRepository<
  Driver,
  typeof Driver.prototype.email,
  DriverRelations
> {

  public readonly driverOrders: HasManyRepositoryFactory<Order, typeof Driver.prototype.email>;

  public readonly cars: HasOneRepositoryFactory<Car, typeof Driver.prototype.email>;

  constructor(
    @inject('datasources.db') dataSource: DbDataSource, @repository.getter('OrderRepository') protected orderRepositoryGetter: Getter<OrderRepository>, @repository.getter('CarRepository') protected carRepositoryGetter: Getter<CarRepository>,
  ) {
    super(Driver, dataSource);
    this.cars = this.createHasOneRepositoryFactoryFor('cars', carRepositoryGetter);
    this.registerInclusionResolver('cars', this.cars.inclusionResolver);
    this.driverOrders = this.createHasManyRepositoryFactoryFor('driverOrders', orderRepositoryGetter,);
    this.registerInclusionResolver('driverOrders', this.driverOrders.inclusionResolver);
  }
}
