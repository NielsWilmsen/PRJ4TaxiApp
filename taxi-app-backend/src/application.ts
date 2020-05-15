import {BootMixin} from '@loopback/boot';
import {ApplicationConfig} from '@loopback/core';
import {
  RestExplorerBindings,
  RestExplorerComponent,
} from '@loopback/rest-explorer';
import {RepositoryMixin} from '@loopback/repository';
import {RestApplication} from '@loopback/rest';
import {ServiceMixin} from '@loopback/service-proxy';
import path from 'path';
import {MySequence} from './sequence';
import {AuthenticationBindings} from '@loopback/authentication';
import {MyAuthMetadataProvider,
        MyAuthAuthenticationStrategyProvider,
        MyAuthActionProvider,
        MyAuthBindings} from './auth';
import multer from 'multer';
import {FILE_UPLOAD_SERVICE, STORAGE_DIRECTORY} from './keys';

export class TaxiApplication extends BootMixin(
  ServiceMixin(RepositoryMixin(RestApplication)),
) {
  constructor(options: ApplicationConfig = {}) {
    super(options);

    // Set up the custom sequence
    this.sequence(MySequence);

    // Set up default home page
    this.static('/', path.join(__dirname, '../public'));

    // Customize @loopback/rest-explorer configuration here
    this.configure(RestExplorerBindings.COMPONENT).to({
      path: '/explorer',
    });
    this.component(RestExplorerComponent);

    // Configure file upload with multer options
    //NEW
    this.configureFileUpload(options.fileStorageDirectory);

    this . bind( AuthenticationBindings .METADATA) . toProvider (MyAuthMetadataProvider) ;
    this . bind(MyAuthBindings .STRATEGY) . toProvider (MyAuthAuthenticationStrategyProvider) ;
    this . bind( AuthenticationBindings .AUTH_ACTION) . toProvider (MyAuthActionProvider) ;

    this.projectRoot = __dirname;
    // Customize @loopback/boot Booter Conventions here
    this.bootOptions = {
      controllers: {
        // Customize ControllerBooter Conventions here
        dirs: ['controllers'],
        extensions: ['.controller.js'],
        nested: true,
      },
    };
  }

  /**
   * Configure `multer` options for file upload - NEW
   */
  protected configureFileUpload(destination?: string) {
    // Upload files to `dist/.sandbox` by default
    destination = destination ?? path.join(__dirname, '../uploads');
    this.bind(STORAGE_DIRECTORY).to(destination);
    const multerOptions: multer.Options = {
      storage: multer.diskStorage({
        destination,
        // Use the original file name as is
        filename: (req, file, cb) => {
          cb(null, file.originalname);
        },
      }),
    };
    // Configure the file upload service with multer options
    this.configure(FILE_UPLOAD_SERVICE).to(multerOptions);
  }
}
